pkgs:
    let p = pkgs; in
    rec
    { write-js-file =
        { name
        , js
        , node ? p.nodejs
        , destination ? ""
        }:
        let
          js' =
            if node == null then js
              js
            else
              ''
              #! ${node}/bin/node
              ${js}
              '';
        in
        p.writeTextFile
          { name = name;
            text = js';
            executable = !builtins.isNull node;
            inherit destination;
            # TODO: add checkPhase
          };

      write-js-script = name: js: write-js-file { inherit name js; };

      write-js-script-bin = name: js:
        write-js-file { inherit name js; destination = "/bin/${name}"; };
    }
