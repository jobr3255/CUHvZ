import { withIonLifeCycle } from '@ionic/react';
import React from "react";
import EventsController from "../controllers/EventsController"

/**
 * EventsPage state variables
 */
interface EventsPageState {
  weeklongs: JSX.Element[],
  lockins: JSX.Element[]
}

/**
 * EventsPage component
 */
class EventsPage extends React.Component<any, EventsPageState> {

  constructor(props: any) {
    super(props);
    this.state = {
      weeklongs: [],
      lockins: []
     };
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    var eventsController = new EventsController();
    var weeklongs = await eventsController.getWeeklongListings();
    var lockins = await eventsController.getLockinListings();
    this.setState({
      weeklongs: weeklongs,
      lockins: lockins
    });
  }

  render() {
    return (
        <div className="container">
          <div className="content lightslide-box white">
            <h1 className='white' ><strong>Weeklongs</strong></h1>
            <div>
              An HvZ weeklong is a whole-campus game of zombie tag. During a single week, players play the game alongside attending classes and carrying out their lives. But the game is only played outside 8:00-5:00. Starting as a human player, you will do your best to avoid being tagged by zombie players while also completing mission objectives. In short: you will try to survive the week.
              <br/><br/>
              Players are marked by a bandana, provided by us. Human players wear their bandana on their arm. Zombie players wear their bandana on their forehead. Game moderators will be marked by two bandanas. When you are zombified, you move your bandana from your arm to your head. You are now a zombie.
              <br/><br/>
              For a list of the complete rules visit the <a href="/rules">rules page</a>
            </div>
            <hr/>
            <div>
              {this.state.weeklongs}
            </div>
            <h1 className='white' ><strong>Lock-Ins</strong></h1>
						<div>
							An HvZ lock-in is a huge game of zombie tag that occurs in the Engineering center about once a semester, usually the friday before spring or fall break. The night usually consists of 2 rounds. In these rounds there will be a couple of people that start off as zombies that are trying to turn all of the humans into zombies. The humans meanwhile are attempting to complete a mission before they are all zombified. If the humans complete this mission they win. If all of the humans are zombified before they can complete their mission the zombies win. Zombies can turn humans by tagging them, humans can defend themselves with nerf blaster or sock bombs.
						</div>
						<br/>
						<div>
							Check-in begins at 9 pm and doors close at 10 pm. Make sure to arrive to the event before doors closing, we are not allowed to let anyone in after that. There is parking available in the engineering parking structure and the C4C parking lot. <a href='/images/where-to-park.png' target='_blank'>Where to park.</a>
						</div>
						<br/>
						<div>
							Need a map of the engineering center?
							<br/>
							<a href='/images/ec-maps/basement.png' target='_blank'>Basement</a> |
							<a href='/images/ec-maps/first-floor.png' target='_blank'> 1st floor</a> |
							<a href='/images/ec-maps/second-floor.png' target='_blank'> 2nd floor</a> |
							<a href='/images/ec-maps/printable.pdf' target='_blank'> Full map</a> |
							<a href='/images/ec-maps/printable-single-sheet.pdf' target='_blank'> Full map (single page)</a>
						</div>
						<hr/>
            <div>
              {this.state.lockins}
            </div>
          </div>
        </div>
    );
  }
}

export default withIonLifeCycle(EventsPage);
