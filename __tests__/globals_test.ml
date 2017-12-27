open Jest
open Expect

let _ =
  test "pass" (fun _ ->
    pass);

  Skip.test "fail" (fun _ ->
    fail "");

  test "test" (fun _ ->
    expect (1 + 2) |> toBe 3);
    
  Skip.test "test - expect fail" (fun _ ->
    expect (1 + 2) |> toBe 4);
  
  testAsync "testAsync" (fun done_ ->
    done_ (expect (1 + 2) |> toBe 3));
    
  Skip.testAsync "testAsync - no done" (fun _ -> ());

  Skip.testAsync "testAsync - expect fail" (fun done_ ->
    done_ (expect (1 + 2) |> toBe 4));
  
  testPromise "testPromise" (fun _ ->
    Js.Promise.resolve (expect (1 + 2) |> toBe 3));

  Skip.testPromise "testPromise - reject" (fun _ ->
    Js.Promise.reject (Failure ""));

  Skip.testPromise "testPromise - expect fail" (fun _ ->
    Js.Promise.resolve (expect (1 + 2) |> toBe 4));

  testAll "testAll" ["foo"; "bar"; "baz"] (fun input ->
    expect (Js.String.length input) |> toEqual 3);
  testAll "testAll - tuples" [("foo", 3); ("barbaz", 6); ("bananas!", 8)] (fun (input, output) ->
    expect (Js.String.length input) |> toEqual output);
  
  describe "describe" (fun _ ->
    test "some aspect" (fun _ -> expect (1 + 2) |> toBe 3)
  );
  
  describe "beforeAll" (fun _ -> 
    let x = ref 0 in
    
    beforeAll (fun _ -> x := !x + 4);
    test "x is 4" (fun _ -> expect !x |> toBe 4);
    test "x is still 4" (fun _ -> expect !x |> toBe 4);
  );
  
  describe "beforeEach" (fun _ -> 
    let x = ref 0 in
    
    beforeEach (fun _ -> x := !x + 4);
    test "x is 4" (fun _ -> expect !x |> toBe 4);
    test "x is suddenly 8" (fun _ -> expect !x |> toBe 8);
  );
  
  describe "afterAll" (fun _ -> 
    let x = ref 0 in
    
    describe "phase 1" (fun _ ->
      afterAll (fun _ -> x := !x + 4);
      test "x is 0" (fun _ -> expect !x |> toBe 0)
    );
    
    describe "phase 2" (fun _ -> 
      test "x is suddenly 4" (fun _ -> expect !x |> toBe 4)
    );
  );
  
  describe "afterEach" (fun _ -> 
    let x = ref 0 in
    
    afterEach (fun _ -> x := !x + 4);
    test "x is 0" (fun _ -> expect !x |> toBe 0);
    test "x is suddenly 4" (fun _ -> expect !x |> toBe 4);
  );
  
  describe "Only" (fun _ ->
   (* See globals_only_test.ml *)
   ()
  );

  describe "Skip" (fun _ ->
    Skip.test "Skip.test" (fun _ -> expect (1 + 2) |> toBe 3);

    Skip.testAsync "Skip.testAsync" (fun done_ ->
      done_ (expect (1 + 2) |> toBe 3));

    Skip.testPromise "Skip.testPromise" (fun _ ->
      Js.Promise.resolve (expect (1 + 2) |> toBe 3));

    Skip.testAll "testAll" ["foo"; "bar"; "baz"] (fun input ->
      expect (Js.String.length input) |> toEqual 3);
    Skip.testAll "testAll - tuples" [("foo", 3); ("barbaz", 6); ("bananas!", 8)] (fun (input, output) ->
      expect (Js.String.length input) |> toEqual output);

    Skip.describe "Skip.describe" (fun _ ->
      test "some aspect" (fun _ -> expect (1 + 2) |> toBe 3)
    );
  );
  