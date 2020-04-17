import React from 'react';
import Player,{Deceased} from "../../models/Player";
import './PlayersTable.css';

/**
 * PlayersTable properties
 */
interface PlayersTableProps {
  id: string,
  players: Array<Player>,
  headers: Array<string>, // Username, Points, Hunger, Kills, Type, Starved
  className?: string,
  rerenderCallback?: () => void
}

/**
 * PlayersTable states variables
 */
interface PlayersTableStates {
  players: Array<Player>,
  sortID: string,
  sortOrder: number
}


/**
 * Renders a table of Player objects. Customize by changing the headers property to display the rows you want to display
 */
export default class PlayersTable extends React.Component<PlayersTableProps, PlayersTableStates> {
  constructor(props: PlayersTableProps) {
    super(props);
    this.state = {
      players: props.players,
      sortID: "",
      sortOrder: 1
    }
    this.handleSort = this.handleSort.bind(this);
  }

  /**
   * Sorts the rows of the table by the header clicked
   */
  handleSort(e: any) {
    var element = (e.target as HTMLElement);
    var sortID = element.id;
    var sortOrder = this.state.sortOrder;
    if(this.state.sortID === sortID){
      sortOrder = -sortOrder;
    }else{
      sortOrder = 1;
    }
    var players = this.state.players;
    switch(sortID){
      case "Username":
        players.sort((a: Player, b: Player) => (a.getUsername() > b.getUsername()) ? sortOrder : -sortOrder);
        break;
      case "Points":
        players.sort((a: Player, b: Player) => (a.getPoints() < b.getPoints()) ? sortOrder : -sortOrder);
        break;
      case "Hunger":
        players.sort((a: Player, b: Player) => (a.getStarveDate() < b.getStarveDate()) ? sortOrder : -sortOrder);
        break;
      case "Kills":
        players.sort((a: Player, b: Player) => (a.getKills() > b.getKills()) ? sortOrder : -sortOrder);
        break;
      case "Type":
        players.sort((a: Player, b: Player) => (a.getType() > b.getType()) ? sortOrder : -sortOrder);
        break;
      case "Starved":
        players.sort((a: Player, b: Player) => (a.getStarveDate() > b.getStarveDate()) ? sortOrder : -sortOrder);
        break;
    }
    this.setState({
      players: players,
      sortID: sortID,
      sortOrder: sortOrder
    });
    if(this.props.rerenderCallback){
      console.log("trigger rerender");
      this.props.rerenderCallback();
    }
  }

  render() {
    var headers = [];
    var keyIndex = 0;
    for (let header of this.props.headers) {
      headers.push(
        <span key={keyIndex++} className={`table-cell ${header}`} onClick={this.handleSort} id={header}>{header}</span>
      );
    }
    var players = this.state.players;
    var playerRows = [];
    keyIndex = 0;
    for (let player of players) {
      var tmpRows = [];
      for (let header of this.props.headers) {
        var value: any;
        var userType = "";
        switch(header){
          case "Username":
            if(player.getClearance() > 0)
              value = <>{player.getUsername()}<sub className="mod">M</sub></>;
            else
              value = player.getUsername();
            userType = player.constructor.name;
            break;
          case "Points": value = player.getPoints(); break;
          case "Hunger": value = player.getStarveTimer(); break;
          case "Kills": value = player.getKills(); break;
          case "Type": value = player.getType(); break;
          case "Starved":
            if(player instanceof Deceased)
              value = (player as Deceased).getStarvedDate();
            break;
        }
        tmpRows.push(
          <span key={keyIndex++} className={`table-cell ${header} ${userType}`} id={header} onClick={this.handleSort}>{value}</span>
        );
      }
      playerRows.push(
        <tr key={keyIndex++}>
          <td>
            {tmpRows}
          </td>
        </tr>
      );
    }
    return (
      <table className="players-table">

        <thead>
          <tr>
            <th>
              {headers}
            </th>
          </tr>
        </thead>

        <tbody className={this.props.className} id={`${this.props.id}-tbody`}>
        {playerRows}
        </tbody>
      </table>
    );
  }
}
