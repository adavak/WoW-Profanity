local AddonName, Addon = ...
 
if (GetLocale() == "frFR") then
    Addon.Loc = {
        Title = "Mécagone",
        Drills = {
            ["Prefix"] = "Foreuse active en",
            "DR-TR28",
            "DR-TR35",
            "DR-CC61",
            "DR-CC73",
            "DR-CC88",
            "DR-JD41",
            "DR-JD99",
        },
        Armories = "Armurerie trouvée en",
        Rares = {
            [151934] = "Arachnoide Moissonneur",
            [150394] = "Robot-coffre blindé",
            [153200] = "Brûlebouille",
            [151308] = "Boggac Casse-crâne",
            [152001] = "Croc-os",
            [154739] = "Mécagelée Caustique",
            [151569] = "Gueule des Profondeurs",
            [150342] = "Brise-Terre Gulroc",
            [154153] = "Massacreur KX-T57",
            [151202] = "Manifestation Infâme",
            [151884] = "Fongicien Furieux",
            [135497] = "Fongicien Furieux",
            [153228] = "Pignologue Clétoile",
            [153205] = "Gemmicide",
            [154701] = "Croque-Ecrou Gavé",
            [151684] = "Mâchebrise",
            [152007] = "Autopscie",
            [151933] = "Robot-Bête Défectueux",
            [151124] = "Annulateur Mécagonien",
            [151672] = "Mécatarentule",
            [151627] = "Mr. Réparetout",
            [151296] = "Vengeur OOX/MG",
            [153206] = "Vieux Grande-Défenses",
            [152764] = "Lixiviaure Oxidé",
            [151702] = "Paol Pêchemare",
            [150575] = "Gronderoche",
            [152182] = "Rouilleplume",
            [155583] = "Récupince",
            [150937] = "Bruinemer",
            [153000] = "Electreine P'Omp",
            [153226] = "Chante-acier Freza",
            [155060] = "Sosie",
            [152113] = "Cleptoboss",
            [151940] = "Oncle T'Rogg",
            [151625] = "Le Roi-boulon",
            [151623] = "Le Roi-boulon (Monté)",
            [154342] = "Arachnoide Moissonneur (Futur)",
            [154225] = "Le Prince de la Rouille (Futur)",
            [154968] = "Robot-coffre blindé (Futur)",
            [152569] = "Trogg affolé (Vert)",
            [152570] = "Trogg affolé (Bleu)",
            [149847] = "Trogg affolé (Orange)",
        },
        Config = {
            ["Armory"] = {
                "Enable Armory Announcements",
                "Enables/Disables announcing armories to general chat",
            },
            ["Drills"] = {
                "Enable Drill Announcements",
                "Enables/Disables notifying of newly spawned Drills",
            },
            ["DrillSounds"] = {
                "Enable Drill Sounds",
                "Enables/Disables sounds for newly spawned drills"
            },
            ["DrillWaypoints"] = {
                "Enable Drill Waypoints",
                "Enables/Disables automatic waypoints to newly spawned drills",
            }
        },
    }
end