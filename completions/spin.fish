complete --command spin --exclusive --description "Background job spinner" --no-files

complete --command spin --long-option list --short-option l --description "List available spinner sets from sindresorhus" --no-files
complete --command spin --long-option spinner --short-option s --description "Name of the spinner set to use from list" --no-files

complete --command spin --long-option chars --short-option c --description "String of characters that make up the spinner" --no-files
complete --command spin --long-option format --short-option f --description "Customize the spinner display" --no-files
complete --command spin --long-option interval --short-option i --description "Number of seconds between frames" --no-files
complete --command spin --long-option framesize --short-option n --description "Number of characters per frame" --no-files
complete --command spin --long-option error --short-option e --description "File to write errors to"

complete --command spin --long-option help --short-option h --description "Show usage help" --no-files
