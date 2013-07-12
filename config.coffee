
module.exports =

    # DB Settings
    # -----------
    # The settings customizing the app to a gym (used to generate the database
    # fields)

    # Grade mapping
    gradeNames:     [ "Gelb", "Gruen", "Orange", "Blau", "Rot", "Weiss" ]
    gradeValues:    ["- 4c", "", "", "", "", ""]
    gradeCSS:       [ "yellow", "green", "orange", "blue", "red", "white" ]


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

    # The number of boulders a setter is required to put up every month
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

    showUserGradeVoting:    false
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

