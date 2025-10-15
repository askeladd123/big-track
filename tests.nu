let tests = [
    [name, func];
    [sync, {
        big-track sync
    }],
    [create, {
        touch ./bob.txt
        big-track create ./bob.txt
    }]
]

def assert [
    condition: bool,
    message?: string,
    --error-label: record<text: string, span: record<start: int, end: int>>
] {
    if not $condition {
        error make {
            msg: ($message | default "Assertion failed."),
            label: ($error_label | default {
                text: "It is not true.",
                span: (metadata $condition).span,
            })
        }
    }
}

def run_tests [functions, passed, total]: any -> int {
    mut passed = $passed
    for pair in ($functions | enumerate) {
        let text = $"(ansi reset) [($pair.index + 1) / ($total)] ($pair.item.name)"
        print $"(ansi yellow)running($text)" --no-newline
        try { 
            cd (mktemp --directory)
            do $pair.item.func out+err> /tmp/log-test-output # FIXME: this is a workaround for redirecting output to a variable, not performant
            cd ..
            print $"\r(ansi green)success($text)"
            $passed += 1
        } catch {
            print $"\r(ansi red)failure($text)"
            print (open /tmp/log-test-output)
            print $in.rendered
        }
    }
    return $passed
}

def main [] {
    let total = $tests | length
    mut passed = 0

    print $"running ($total) test(if ($total == 1) {''} else {'s'}):"
    $passed = (run_tests $tests $passed $total)
    
    let color = if $passed == $total {ansi green} else {ansi red}
    print $"testing done: ($color)($passed) of ($total)(ansi reset) passed"
}
