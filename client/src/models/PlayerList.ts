import Player, { Human, Zombie, Deceased } from "./Player";

export default class PlayerList {
  private humans: Array<Human>;
  private zombies: Array<Zombie>;
  private deceased: Array<Deceased>;

  constructor() {
    this.humans = [];
    this.zombies = [];
    this.deceased = [];
  }

  addHuman(human: Human) {
    this.humans.push(human);
  }

  addZombie(zombie: Zombie) {
    this.zombies.push(zombie);
  }

  addDeceased(dead: Deceased) {
    this.deceased.push(dead);
  }

  /***************
      GETTERS
   ***************/

  getAllPlayers(): Array<Player> {
    return this.humans.concat(this.zombies, this.deceased);
  }

  getHumans(): Array<Human> {
    return this.humans;
  }

  getZombies(): Array<Zombie> {
    return this.zombies;
  }

  getDeceased(): Array<Deceased> {
    return this.deceased;
  }
}
