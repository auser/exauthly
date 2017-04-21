{application,guardian_db,
             [{description,"DB tracking for token validity"},
              {modules,['Elixir.GuardianDb',
                        'Elixir.GuardianDb.ExpiredSweeper',
                        'Elixir.GuardianDb.Token']},
              {registered,[]},
              {vsn,"0.8.0"},
              {applications,[kernel,stdlib,elixir,logger]}]}.
