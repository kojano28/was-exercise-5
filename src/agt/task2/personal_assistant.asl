// personal assistant agent 

/* Task 2 Start of your solution */

/* Task 2.3: initial beliefs */
preference(artificial_light, 2).
preference(natural_light, 1).
preference(vibrations, 0).

/* Task 2.3: additional rule for best wake up option and updated for Task 2.5 */
best_option(Option) :- 
    preference(Option, Rank) & not(used(Option)) & not(preference(OtherOpt, OtherRank) & not(used(OtherOpt)) & OtherRank < Rank).

/* Task 2.1 */
@lights_added_plan
+lights(STATE)
: true
<- 
.print("Lights have the state: ", STATE, ".");
.

@lights_removed_plan
-lights(STATE)
: true
<- 
.print("Lights have the state: ", STATE, ".");
.

@blinds_added_plan
+blinds(STATE)
: true
<- 
.print("Blinds have the state: ", STATE, ".");
.

@blinds_removed_plan
-blinds(STATE)
: true
<- 
.print("Blinds have the state: ", STATE, ".");
.

@mattress_added_plan
+mattress(STATE)
: true
<- 
.print("Mattress has the state: ", STATE, ".");
.

@mattress_removed_plan
-mattress(STATE)
: true
<- 
.print("Mattress has the state: ", STATE, ".");
.

@wristband_added_plan
+wristband(STATE)
: true
<- 
.print("wristband has the state: ", STATE, ".");
.

@wristband_removed_plan
-wristband_state(STATE)
: true
<- 
.print("wristband has the state: ", STATE, ".");
.

/* Task 2.2*/
@upcoming_event_now_awake_plan
+upcoming_event("now")
: owner_state("awake")
<- 
    .print("Enjoy your event")
.

@upcoming_event_now_asleep_plan
+upcoming_event("now")
: owner_state("asleep")
<- 
    .print("Starting wake-up routine");
    !wake_up_user;
.

/* Task 2.4 and updated for Task 2.5*/

@wake_up_user_vibrations
+!wake_up_user
: owner_state("asleep") & best_option(vibrations)
<- 
    setVibrationsMode;
    +used(vibrations);
    .print("Waking up user using vibrations mode");
    !wake_up_user;
.


@wake_up_user_artificial
+!wake_up_user
: owner_state("asleep") & best_option(artificial_light)
<- 
    turnOnLights;
    +used(artificial_light);
    .print("Waking up user using artificial light");
    !wake_up_user;
.


@wake_up_user_natural
+!wake_up_user
: owner_state("asleep") & best_option(natural_light)
<- 
    raiseBlinds;
    +used(natural_light);
    .print("Waking up user using natural light");
    !wake_up_user;
.


@wake_up_success
+!wake_up_user
: owner_state("awake")
<- 
    .print("Design objective achieved: User is awake");
.

/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }