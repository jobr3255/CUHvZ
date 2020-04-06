import { withIonLifeCycle } from '@ionic/react';
import React from 'react';

class Rules extends React.Component {
  render() {
    return(
    	<div className="container">
    		<div className="content lightslide-box white">
    			<h2><strong>Weeklong</strong></h2>
    			<div>
    				<h5>1. Don’t be a douchebag</h5>
    				<ul className="plain">
    					<li className="plain">Don’t use non-players as human shields</li>
    					<li className="plain">Don’t remove your bandana to avoid being killed</li>
    					<li className="plain">Don’t deny that you weren’t tagged/stunned</li>
    					<li className="plain">Don’t make mountains out of molehills, this is a game, not life or death</li>
    				</ul>
    			</div>
    			<div>
    				<h5>2. <strong>No nerf on campus!</strong></h5>
    				<ul className="plain">
    					<li className="plain">We wish we could use nerf too, but unfortunately no nerf is allowed on campus at all!!!</li>
    					<li className="plain">You can protect yourself with rolled up socks (preferably clean thanks) and other soft similarly-sized projectiles</li>
    				</ul>
    			</div>
    			<div>
    				<h5>3. Wear your bandanas when you are playing</h5>
    				<ul className="plain">
    					<li className="plain">All participants wear bandanas around their ankles to designate that they are a player</li>
    					<li className="plain">Humans wear bandanas on their arms</li>
    					<li className="plain">Zombies wear bandanas around their heads</li>
    				</ul>
    				<img src="images/human.jpg" alt="Human with bandana" style={{width: "40%"}}/>
    				<img src="images/zombie.jpg" alt="Zombie with bandana" style={{width: "40%"}}/>
    			</div>
    			<div>
    				<h5>4. Don’t involve non players in the game</h5>
    				<ul className="plain">
    					<li className="plain">If someone isn’t wearing two Mod-provided bandanas (one bright yellow on the ankle and one bright green on the head or arm) don’t try to involve them in the game in any way</li>
    					<li className="plain">We can only host these games if the whole CU community feels safe</li>
    				</ul>
    			</div>
    			<div>
    				<h5>5. Only play within the game limits</h5>
    				<ul className="plain">
    					<li className="plain">All buildings are off-limits</li>
    					<li className="plain">No gameplay on anything with wheels (includes bus, bike, Heelies, etc)</li>
    					<li className="plain">Gameplay will only be on Main campus and at designated parks around Boulder</li>
    				</ul>
    				<img src="images/play_area.png" alt="Play area" style={{width: "50%"}}/>
    			</div>
    			<div>
    				<h5>6. Only play within game times</h5>
    				<ul className="plain">
    					<li className="plain">On-campus game times are Monday-Friday 9:00am - 5:00pm</li>
    					<li className="plain">There will also be off-campus missions at local parks in Boulder: details will be provided in daily emails and on the website including starting times and locations</li>
    					<li className="plain">Starting times are typically betwen 5 and 6pm and take around 30 minutes depending on participation</li>
    					<li className="plain">During these off-campus mission Nerf is allowed</li>
    				</ul>
    			</div>
    			<div>
    				<h5>7. Player codes</h5>
    				<ul className="plain">
    					<li className="plain">Always have your player code on you to give to a zombie when you get tagged</li>
    					<li className="plain">Have your code on a notecard, a screenshot on your phone--any way you can quickly access it is fine</li>
    					<li className="plain">You can find your player code on your profile page</li>
    				</ul>
    			</div>
    			<div>
    				<h5>Other Notes:</h5>
    				<ul className="plain">
    					<li className="plain">All players must sign up on the website and fill out a safety waiver before playing</li>
    				</ul>
    			</div>

    			<hr/>

    			<h2><strong>Lock-in</strong></h2>
    			<div>
    				<iframe title="HvZ rules" src="https://onedrive.live.com/embed?cid=22F6EE2CC3A51664&amp;resid=22f6ee2cc3a51664%212687&amp;authkey=ABuXzNzoCWPOKNQ&amp;em=2&amp;wdAr=1.7777777777777777" width="610px" height="367px" frameBorder="0">This is an embedded <a target="_blank" href="https://office.com" rel="noopener noreferrer">Microsoft Office</a> presentation, powered by <a target="_blank" rel="noopener noreferrer" href="https://office.com/webapps">Office</a>.</iframe>
    			</div>

    			<div>
    				<h5>Rule #1. Don't be a douchebag</h5>
    				What this means:
    				<ul className="plain">
    					<li className="plain">We want this game to be fun for everyone, so keep other players in mind.</li>
    					<li className="plain">Examples of being a douchebag include:</li>
    					<ul className="plain">
    						<li className="plain">Blasting your fellow players in the face</li>
    						<li className="plain">Getting mad or yelling at players for tagging you</li>
    						<li className="plain">Lying about whether you’re human or zombie, stunned or spawned</li>
    						<li className="plain">Blasting people who are not in *the game*, or blasting players while you are not in
    						*the game*</li>
    						<li className="plain">Treating a player as though they are in *the game* while they are not involved either
    						due to discussion with a moderator or because they have an emergency</li>
    						<li className="plain">Treating a player as though they are in *the game* while they are not involved either
    						due to discussion with a moderator or because they have an emergency</li>
    					</ul>
    				</ul>
    			</div>

    			<div>
    				<h5>All Players</h5>
    				<ul className="plain">
    					<li className="plain">If not sure who got tagged/stunned first, players must solve the dispute with Rock-Paper-
    					Scissors</li>
    					<li className="plain">No shields unless specifically provided</li>
    					<li className="plain">Shoes are mandatory</li>
    				</ul>
    			</div>

    			<div>
    				<h5>Humans</h5>
    				<ul className="plain">
    					<li className="plain">Have bandana on arm</li>
    					<li className="plain">Use nerf or socks to defend themselves</li>
    					<li className="plain">Become zombies when tagged by a zombie</li>
    					<li className="plain">Goal: complete missions and stay alive</li>
    				</ul>
    			</div>

    			<div>
    				<h5>Zombies</h5>
    				<ul className="plain">
    					<li className="plain">Have bandana on head</li>
    					<li className="plain">Tag humans to turn them into zombies</li>
    					<li className="plain">Stunned when hit by projectile from humans</li>
    					<li className="plain">Clearly show they are out of the game when stunned</li>
    					<li className="plain">Must audibly count down from 10 for the last 10 seconds before they respawn</li>
    					<li className="plain">Stun timer is 60 seconds unless otherwise stated</li>
    					<li className="plain">Blaster tags don’t count</li>
    					<li className="plain">Goal: tag all humans</li>
    				</ul>
    			</div>

    			<div>
    				<h5>Playing Area</h5>
    				<ul className="plain">
    					<li className="plain">Engineering Center 1st, 2nd, 1st basement</li>
    					<li className="plain">DLC 1st, 2nd, 1st basement</li>
    					<li className="plain">No play in elevators</li>
    					<li className="plain">No kicking open doors</li>
    					<li className="plain">Be careful of stairs, don't run and don't jump</li>
    					<li className="plain">Bathrooms are safe zones</li>
    					<li className="plain">Respect the space</li>
    				</ul>
    			</div>

    			<div>
    				<h5>Blaster Restrictions</h5>
    				<ul className="plain">
    					<li className="plain">No hard tipped darts (FVJ) or modified darts. Stefans are fine</li>
    					<li className="plain">No blow guns on any kind</li>
    					<li className="plain">120 FPS cap</li>
    					<li className="plain">No realistic paint jobs unless clearly marked with brightly colored ribbon or tape</li>
    				</ul>
    			</div>
    		</div>
      </div>
    );
  }
}

export default withIonLifeCycle(Rules);
