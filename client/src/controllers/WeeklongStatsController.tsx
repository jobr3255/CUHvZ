import API from "../util/API";
import Weeklong from "../models/Weeklong";
import PlayerList from "../models/PlayerList";
import { Human, Zombie, Deceased } from "../models/Player";
import WeeklongController from "./WeeklongController";

/**
 * Controller for the WeeklongStatsPage
 */
export default class WeeklongStatsController extends WeeklongController {

  /**
   * Formats the stun timer from a Weeklong object
   */
  formatStunTimer(weeklong: Weeklong): string {
    var totalTime = weeklong.getStunTimer();
    var min = Math.floor(totalTime / 60);
    var seconds = totalTime - (min * 60);
    var stunTimer = `${min}:${seconds}`
    if (seconds === 0)
      stunTimer = `${min}:00`;
    else if (seconds < 10)
      stunTimer = `${min}:0${seconds}`
    return stunTimer;
  }

  /**
   * Calls the API and sets the players in a Weeklong object
   */
  async setPlayers(weeklong: Weeklong) {
    let playersData = await API.get(`/api/weeklong/${weeklong.getID()}/players`)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    var players = new PlayerList();
    for (var data of playersData) {
      switch (data["status"]) {
        case "human":
          players.addHuman(new Human(data));
          break;
        case "zombie":
          players.addZombie(new Zombie(data));
          break;
        case "deceased":
          players.addDeceased(new Deceased(data));
          break;
      }
    }
    weeklong.setPlayers(players);
  }
}
