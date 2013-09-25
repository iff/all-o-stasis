
module.exports =

    # Required Settings
    # -----------------
    # This section customizes the app to your gym (grades and sectors).
    # Make sure that all the mapping arrays have the same number of  elements
    # (or keys)! For further settings see comments below

    # Name of the mongo database (use your gyms name)
    databaseName: 'minimumtwo'

    # Maps grade names to grade values (d'oh)..
    grades:         { Gelb: "[1a  -- 4c]",    Gruen: "[5a  -- 6a]", Orange: "[6a+ -- 6b+]", Blau:  "[6c  -- 7a]", Rot: "[7a+ -- 7b+]",    Weiss: "[7c  -- ?]" }

    # This CSS class will be applied everywhere were grades appear (boulder
    # list, detail view...).
    gradeCSSClass:  { Gelb: "yellow", Gruen: "green", Orange: "orange", Blau: "blue", Rot: "red", Weiss: "white" }

    # Mapping Sectors to images
    sectors:        { "Big Boss":  "sectors/BigBoss.png", "Dune":  "sectors/Dune.png", "Starship":  "sectors/Starship.png", "Klagemauer":  "sectors/Klagemauer.png", "Kurswand": "sectors/Kurswand.png", "Spektrum 1":  "sectors/Spectrum1.png", "Spectrum 2":  "sectors/Spektrum2.png", "Spektrum 3":  "sectors/Spektrum3.png", "Spektrum 4":  "sectors/Spektrum4.png" }



    # ----------------------- Optional Settings ------------------------------
    # Access Control
    # --------------
    # There are 4 different access control types: guest, user (ticklist/vote),
    # setter and admin.
    # Admin rights  = add, delete, up/downgrade, mark as removed
    # Setter rights = add, mark as removed

    # All Setters are admins
    settersAreAdmins:       false
    admingGroup:            "admin"

    # The name of the group that has admin rights to add boulders and mark
    # boulders as removed
    setterAdminGroup:       "teamsetter"


    # Setter Settings
    # ---------------

    # The number of boulders a setter is required to put up every month (-1
    # for none)
    numMonthlyBoulders:     3

    # Send setter a monthly performance statistic
    sendMonthlyStatisctics: false

    # User Settings
    # -------------
    #
    enableUserAccounts:     false


    # Views Settings
    # --------------
    # Customize some of the views

    showUserGradeVoting:    true
    showDisLike:            true

    showInactiveInTeam:     false


    # Email notifications
    # -------------------
    # The domain for the from address, and the recipient that is used to send
    # notifications.

    email:
        domain:             'admin@minimum-bouldering.ch'
        recipient:          'setter-list@minimum-bouldering.ch'


    # Extended API
    # ------------
    # Enables and configures the API to access statistics

    enableAPI:              false

