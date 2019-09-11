function spin --description 'Background job spinner'

    set --local commands

    set --local chars ''
    set --local setlist bouncingBall

    set --local format '  @\r'
    set --local size 1
    set --local rate 100

    set --local error /dev/stderr

    getopts $argv | while read --local 1 2
        switch "$1"
            case _
                set commands $commands ";$2"

            case c chars
                set chars $2

            case s setlist
                set setlist $2

            case f format
                set format $2

            case n framesize
                set framesize $2

            case r rate
                set rate $2

            case error
                set error $2

            case h help
                printf "Usage: spin COMMANDS [(-s | --style STYLE)] [(-f | --format FORMAT)] \n"
                printf "                     [(-i | --rate FLOAT)] [--error FILE] [(-h | --help)]\n\n"

                printf "\t-s --chars STRING\tInline string to use as the spinner characters.\n"
                printf "\t-f --format FORMAT\tCustomize the spinner display (default: '%s')\n" $format
                printf "\t-r --rate FLOAT\tDetermine the rate between slices (default: $rate)\n"
                printf "\t-n --framesize INT\tSet the size of the spinner frames (default: $framesize)\n"
                printf "\t-l --setlist STRING\tName of the spinner setlist to use (default: $setlist)\n"
                printf "\t-e --error FILE\t\tWrite errors to FILE (default: $error)\n"
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

    if not set --query commands[1]
        return 1
    end

    if set --query setlist
        set jspinners $TMPDIR/spinners.json
        test -e $jspinners
        or curl https://raw.githubusercontent.com/sindresorhus/cli-spinners/master/spinners.json --output $jspinners
        set blob (python3 -c "import json;print(json.loads(open('$jspinners').read())['"$setlist"'])")
        set chars (python3 -c "print(''.join("$blob"['frames']))")
        set framesize (python3 -c "print(len("$blob"['frames'][0]))")
        set rate (python3 -c "print("$blob"['interval'])")
    end

    set size (ruby -e "puts '.' * $framesize")
    set chars (printf "%s\n" "$chars" | grep --only-matching $size)
    set interval (math $rate / 1000)

    set --local tmp (mktemp -t spin.XXX)
    set --local job_id

    fish --command "$commands" >/dev/stdout ^$tmp &

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

    while contains -- $job_id (jobs | cut -d\t -f1 ^ /dev/null)
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

    if test -s $tmp
        command cat $tmp >$error
        command rm -f $tmp
        return 1
    end

    command rm -f $tmp
end
