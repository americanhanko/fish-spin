function spin --description 'Background job spinner'

    set --local commands
    set --local chars '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    set --local format '  @\r'
    set --local size 1
    set --local rate 240
    set --local spinners_source https://raw.githubusercontent.com/sindresorhus/cli-spinners/master/spinners.json

    set --local error /dev/stderr

    getopts $argv | while read --local 1 2
        switch "$1"
            case _
                set commands $commands ";$2"

            case l list
                set list true

            case s spinner
                set spinner $2

            case c chars
                set chars $2

            case f format
                set format $2

            case i interval
                set rate $2

            case n framesize
                set size $2

            case error
                set error $2

            case h help
                printf "Usage: spin [OPTIONS]\n\n"

                printf "The following options are available:\n\n"
                printf "\t-l or --list\t\tList available spinner sets from sindresorhus\n"
                printf "\t-s or --spinner=NAME\tName of the spinner set to use from list (default: $chars)\n"

                printf "\t-c or --chars=CHARS\tString of characters that make up the spinner\n"
                printf "\t-f or --format=FORMAT\tCustomize the spinner display (default: '%s')\n" $format
                printf "\t-i or --interval=FLOAT\tNumber of seconds between frames (default: $rate)\n"
                printf "\t-n or --framesize=SIZE\tNumber of characters per frame (default: $size)\n"
                printf "\t-e or --error=FILE\tWrite errors to FILE (default: $error)\n"
                printf "\n"

                printf "\t-h --help\t\tShow usage help\n"
                printf "\n"
                return

            case '*'
                printf "spin: '%s' is not a valid option\n" $1 >/dev/stderr
                spin --help >/dev/stderr
                return 1
        end
    end

    if not set --query XDG_CACHE_HOME
        echo XDG_CACHE_HOME not set
        return 1
    end

    set --local jspinners $XDG_CACHE_HOME/spinners.json
    test -e $jspinners
    or curl --silent $spinners_source --output $jspinners
    set --local hash (python3 -c "import json;print(json.loads(open('$jspinners').read()))")

    if test -z $argv[1]
        spin --help >/dev/stderr
        return 1
    end

    if set --query list
        python3 -c "print(list("$hash".keys()))" \
            | grep --color=never --only-matching --extended-regexp '\w+' \
            | column -c $COLUMNS
        return 0
    end

    if set --query spinner
        set blob (python3 -c "print("$hash"['"$spinner"'])")
        set chars (python3 -c "print(''.join("$blob"['frames']))")
        set size (python3 -c "print(len("$blob"['frames'][0]))")
        set rate (python3 -c "print("$blob"['interval'])")
    end

    set size (ruby -e "puts '.' * $size")
    set chars (printf "%s\n" "$chars" | grep --only-matching $size)
    set interval (math $rate / 1000)

    set --local tmp (mktemp -t spin.XXX)
    set --local job_id

    fish --command "$commands" >/dev/stdout 2>$tmp &

    set job_id (jobs --last | awk -v FS=\t '
        /[0-9]+\t/{
            jobs[++job_count] = $1
        }
        END {
            for (i = 1; i <= job_count; i++) {
                print(jobs[i])
            }
            exit job_count == 0
        }
    ')

    tput civis

    while contains -- $job_id (jobs | cut -d\t -f1 2>/dev/null)
        if status --is-interactive

            for char in $chars
                printf $format | awk -v char=(printf "%s\n" $char | sed 's/=/\\\=/') '
                {
                    gsub("@", char)
                    printf("%s", $0)
                }
                ' >/dev/stderr

                sleep $interval
            end
        end
    end

    tput cvvis

    if test -s $tmp
        command cat $tmp >$error
        command rm -f $tmp
        return 1
    end

    command rm -f $tmp
end
