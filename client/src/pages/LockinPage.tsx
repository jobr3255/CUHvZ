import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import LockinController from "../controllers/LockinController"

class LockinPage extends React.Component<any, any> {

  constructor(props: any) {
    super(props);
    this.state = {
      lockin: ""
    };
  }

  async componentDidMount() {
    const { match: { params } } = this.props;
    var id = params["id"];
    var lockinController = new LockinController();
    var lockinView = await lockinController.getLockinView(id);
    this.setState({
      lockin: lockinView
    });
  }

  render() {
    return (
      <div className="App signup lightslide">
        <div className="container">
          <div className="row">
            <div className="content lightslide-box">
              {this.state.lockin}
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(LockinPage);
