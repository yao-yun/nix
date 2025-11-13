{ lib }:
rec {
  _toInt =
    str:
    let
      n = builtins.fromJSON str;
    in
    if builtins.isInt n then n else throw "Failed to parse \"${str}\" to int";
  _deepMerge = # from https://discourse.nixos.org/t/nix-function-to-merge-attributes-records-recursively-and-concatenate-arrays/2030/
    lhs: rhs:
    lhs
    // rhs
    // (builtins.mapAttrs (
      rName: rValue:
      let
        lValue = lhs.${rName} or null;
      in
      if builtins.isAttrs lValue && builtins.isAttrs rValue then
        _deepMerge lValue rValue
      else if builtins.isList lValue && builtins.isList rValue then
        lValue ++ rValue
      else
        rValue
    ) rhs);
  _ensureList = v: if builtins.isList v then v else [ v ];
  _ensureStringList =
    v:
    if builtins.isList v then
      v
    else if builtins.isString v then
      [ v ]
    else
      [
        builtins.toString
        v
      ];
  _modulo = a: b: a - (a / b) * b; # ensure a and b are integers before using
  _multiplyStringList =
    listA: listB: delimiter:
    builtins.concatMap (a: map (b: a + (if b != "" then delimiter else "") + b) listB) listA;
  _zipStringList =
    listA: listB: delimiter:
    let
      length = builtins.length listA;
    in
    if length == builtins.length listB then
      builtins.genList (i: (builtins.elemAt listA i) + delimiter + (builtins.elemAt listB i)) length
    else if length == 1 then
      builtins.genList (i: (builtins.elemAt listA 0) + delimiter + (builtins.elemAt listB i)) length
    else if builtins.length listB == 1 then
      builtins.genList (i: (builtins.elemAt listA i) + delimiter + (builtins.elemAt listB 0)) length
    else
      throw "Size not equal";
  mkBinds =
    mods: keys: dispatcher: params: flags:
    let
      _mods = _ensureStringList mods;
      _keys = _ensureStringList keys;
      _dispatcher = _ensureStringList dispatcher;
      _params = _ensureStringList params;
      flaggedBind = "bind" + flags;
    in
    {
      "${flaggedBind}" = _zipStringList (_multiplyStringList _mods _keys ", ") (_multiplyStringList
        _dispatcher
        _params
        ", "
      ) ", ";
    };
  mkBindsParamed =
    mods: keys: dispWithParams: flags:
    let
      _mods = _ensureStringList mods;
      _keys = _ensureStringList keys;

      _dispWithParams = _ensureStringList dispWithParams;
      flaggedBind = "bind" + flags;
    in
    {
      "${flaggedBind}" = _zipStringList (_multiplyStringList _mods _keys ", ") dispWithParams ", ";
    };

  mkFuncBinds =
    mods: keys: bindFunc: flags:
    let
      _mods = _ensureStringList mods;
      _keys = _ensureStringList keys;
      _keys_len = builtins.length keys;
      length = builtins.length _mods * _keys_len;
      flaggedBind = "bind" + flags;
    in
    {
      "${flaggedBind}" = builtins.genList (
        i:
        let
          mod = builtins.elemAt _mods (i / _keys_len);
          key = builtins.elemAt _keys (_modulo i _keys_len);
        in
        "${mod}, ${key}, ${bindFunc mod key}"
      ) length;
    };
  mkNumBinds =
    mod: dispatcher: flags:
    mkFuncBinds mod (builtins.genList (i: toString (i + 1)) 9) (
      _: numKey: dispatcher (_toInt numKey)
    ) flags;
  mkSubmap = name: bindSettings: {
    submaps.${name}.settings = lib.mkMerge bindSettings;
  };
  mergeBinds = (bindList: builtins.foldl' (acc: bind: _deepMerge acc bind) { } bindList);
  expandBinds = (
    bindList:
    let
      _bindList = _ensureList bindList;
    in
    builtins.concatMap (
      bindSet:
      builtins.concatMap (
        attrName:
        let
          values = bindSet.${attrName};
        in
        map (item: "${attrName} = ${item}") values
      ) (builtins.attrNames bindSet)
    ) _bindList
  );
  # tests
  A = [
    (mkBinds "SUPER+ALT" "K" "exec" "somecommand" "e")
    # (mkBinds "SUPER" [ "C" "W" ] [ "closeactivewindow" "exec firefox" ] "in")
    (mkNumBinds "SUPER" (i: "workspace, ${toString i}") "ie")
    (mkBinds "SUPER" "Q" "exec" "kitty" "e")
  ];
  # Transform A to B
  B = mergeBinds A;
  C = expandBinds A;
  D = mkBinds "SUPER" [ "h" "j" "k" "l" ] "movefocus" [
    "l"
    "u"
    "d"
    "r"
  ] "in";
  E = (
    mkBindsParamed [ "$mainMod" "$mainMod+SHIFT" ] "F" [
      "fullscreen"
      "fullscreenstate, 0 2"
    ] ""
  );
}
