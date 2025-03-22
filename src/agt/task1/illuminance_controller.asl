// illuminance controller agent

/* Initial rules */

// Inference rule for inferring the belief requires_brightening if the target illuminance is higher than the current illuminance
requires_brightening
    :-  target_illuminance(Target) 
        & current_illuminance(Current)
        & (Target - Current) >= 100
    .

// Inference rule for inferring the belief requires_darkening if the target illuminance is lower than the current illuminance
requires_darkening
    :-  target_illuminance(Target)  
        & current_illuminance(Current)
        & (Current - Target) >= 100
    .

/* Initial beliefs */

// The agent believes that the target illuminance is 400 lux. Decrease to 350 lux based on Task 1.1 (4.)
target_illuminance(350).

/* Initial goals */

// The agent has the initial goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: every 4000ms, the agent strives to maintain the illuminance in the room at the target level 
*/
@start_plan
+!start
    :   true
    <-  .print("Continuously managing illuminance");
        .wait(4000);
        !manage_illuminance; // creates the goal !manage_illuminance
        !start;
    .



/* 
 * Task 1.1 (2.)
 * Updated plan for increasing illuminance using lights when the weather is cloudy. ()
 * Triggering event: addition of goal !manage_illuminance
 * Context: lights are off, the room requires brightening, and the weather is cloudy.
 * Body: turns on the lights to increase the illuminance.
*/
@increase_illuminance_with_lights_plan
+!manage_illuminance
    :   lights("off")
        & requires_brightening
        & weather("cloudy")
    <-
        .print("Turning on the lights (cloudy weather)");
        turnOnLights;
    .






/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the lights are on and that the room requires darkening
 * Body: the agent performs the action of turning off the lights
*/
@decrease_illuminance_with_lights_plan
+!manage_illuminance
    :   lights("on")
        & requires_darkening
    <-
        .print("Turning off the lights");
        turnOffLights; // performs the action of turning off the lights
    .

/* 
 * Task 1.1 (2.)
 * Updated plan for increasing illuminance using blinds when the weather is sunny.
 * Triggering event: addition of goal !manage_illuminance
 * Context: blinds are lowered, the room requires brightening, and the weather is sunny.
 * Body: raises the blinds to increase the illuminance.
*/
@increase_illuminance_with_blinds_plan
+!manage_illuminance
    :   blinds("lowered")
        & requires_brightening
        & weather("sunny")
    <-
        .print("Raising the blinds (sunny weather)");
        raiseBlinds;
    .


/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the blinds are raised and that the room requires darkening
 * Body: the agent performs the action of lowering the blinds
*/
@decrease_illuminance_with_blinds_plan
+!manage_illuminance
    :   blinds("raised")
        & requires_darkening
    <-
        .print("Lowering the blinds");
        lowerBlinds; // performs the action of lowering the blinds
    .

/* 
 * Task 1.1 (1.)
 * Plan for handling the case when the current illuminance is equal to the target iluminance
 * Triggering event: addition of the goal !manage_illuminance
 * Context: the current illuminance is equal to the target illuminance
 * Body: prints a message indicating that the design objective has been achieved
*/
@objective_achieved_plan
+!manage_illuminance
    :   current_illuminance(Target)
        & target_illuminance(Target)
    <-
        .print("Design objective achieved: current illuminance equals target (", Target, " lux).");
    .


/* 
 * Task 1.1 (3.)
 * Plan for reacting to the deletion of the belief weather("sunny")
 * Triggering event: deletion of the belief weather("sunny")
 * Context: the blinds are currently raised
 * Body: prints a message and lowers the blinds
*/
@lower_blinds_on_cloudy_plan
- weather("sunny")
    :   blinds("raised")
    <-
        .print("Weather is no longer sunny and blinds are raised. Lowering the blinds.");
        lowerBlinds;
    .



/* 
 * Plan for reacting to the addition of the belief current_illuminance(Current)
 * Triggering event: addition of belief current_illuminance(Current)
 * Context: true (the plan is always applicable)
 * Body: prints the current illuminance conditions in the room
*/
@current_illuminance_plan
+current_illuminance(Current)
    :   true
    <-
        .print("Current illuminance level: ", Current)
    .

/* 
 * Plan for reacting to the addition of the belief weather(State)
 * Triggering event: addition of belief weather(State)
 * Context: true (the plan is always applicable)
 * Body: prints the weather conditions
*/
@weather_plan
+weather(State)
    :   true
    <-
        .print("The weather is ", State);
    .

/* 
 * Plan for reacting to the addition of the belief blinds(State)
 * Triggering event: addition of belief blinds(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the blinds
*/
@blinds_plan
+blinds(State)
    : true
    <-
        .print("The blinds are ", State);
    .

/* 
 * Plan for reacting to the addition of the belief lights(State)
 * Triggering event: addition of belief lights(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the lights
*/
@lights_plan
+lights(State)
    : true
    <- 
        .print("The lights are ", State);
    .

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }
