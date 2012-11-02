<%

class Test {
    FAILURES = [];
    CASES = [];
    
    class Failure extends Error {
    }

    def self.assertions         { @@assertions ||= 0; }
    def self.assertions=(val)   { @@assertions = val; }
    
    def self.failures           { @@failures ||= 0; }
    def self.failures=(val)     { @@failures = val; }
    
    def self.passes             { @@passes ||= 0; }
    def self.passes=(val)       { @@passes = val; }
    
    def assert(what, message = "Assertion failed") {
        Test.assertions++;
        throw Failure.new(message) unless what;
    }
    
    def flunk {
        assert(false, "flunked");
    }
    
    def assert_equal(expect, what) {
        assert(expect == what, "Expected " + expect.inspect + ", got " + what.inspect);
    }
    
    def assert_unequal(expect, what) {
        assert(expect != what, "Expected value to not equal " + expect.inspect);
    }
    
    def assert_is_a(klass, what) {
        assert(what.is_a(klass), "Expected " + what.inspect + " to be a " + klass.name);
    }
    
    def assert_throws(klass, fn) {
        Test.assertions++;
        try {
            fn.call;
        } catch e {
            if e.is_a(klass) {
                return;
            }
            throw e; # rethrow
        }    
        throw Failure.new("Expected callback to throw");
    }
    
    def self.run {
        obj = new();
        for method in obj.own_methods {
            next unless md = %r{^test_(.*)$}.match(method);
            try {
                obj.before if obj.responds_to("before");
                obj.send(method);
                print(".");
                Test.passes++;
                GC.run;
            } catch e {
                Test.failures++;
                print("F");
                FAILURES.push([name() + " " + md[1], e]);
            }
        }
    }
    
    def self.register {
        CASES.push(self);
    }
}

for file in ARGV {
    require(file);
}

for test in Test::CASES {
    test.run;
}

print("\n\n");

for test_name, failure in Test::FAILURES {
    print(failure.name, " in ", test_name, " - ", failure.message, "\n");
    for frame in failure.backtrace {
        next if frame.file == "test/test.sl";
        print("    ", frame, "\n");
    }
    print("\n");
}

print("Tests finished. ", Test.passes, " passes, ", Test.failures, " failures, ", Test.assertions, " assertions.\n");
exit(1) if Test::FAILURES.any;