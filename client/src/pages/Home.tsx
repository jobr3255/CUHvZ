import { IonContent, IonHeader, IonPage, withIonLifeCycle } from '@ionic/react';
import React, { Component } from 'react';
import { Helmet } from "react-helmet";
import axios from 'axios';

class Home extends Component {

  /*
    Fires when entering this page
  */
  ionViewWillEnter() {
    // console.log("ionViewWillEnter fired");
    // axios.get(`/api/weeklongs`)
    //   .then(res => {
    //     console.log(res);
    //   })
  }

  ionViewDidEnter(){
    // console.log("ionViewDidEnter fired");
  }

  render() {
    return (
      <div className="App container">
        <div className="five columns">
          <h1 className="section-heading">Humans
          <span className="white"> versus </span>Zombies</h1>
          <h2 className="grey subheader">University of Colorado <strong className="deeporange">Boulder</strong></h2>
          <img src="/images/skull.png" className="u-max-full-width" alt="Skull"/>
        </div>
        <div className="six columns lightslide-box content">
          <h5>
          Humans vs Zombies is a modified tag game in which students use Nerf blasters, tactics, and teamwork to survive a mock zombie apocalypse. Once tagged by a zombie player, the human becomes a zombie. The nerf equipment is used to stun and temporarily disable the oncoming zombie threat. Humans vs Zombies at CU Boulder is an organization that hold large scale events where CU students, alumni, and students from other schools can gather and survive the apocalypse together.
          </h5>
        </div>
      </div>
    );
  }
}
// <IonPage>
//   <Helmet>
//       <title>Home</title>
//   </Helmet>
//   <IonContent>
//   Hi
//   </IonContent>
// </IonPage>
export default withIonLifeCycle(Home);

  // <IonPage>
  //   <IonHeader>
  //     <Helmet>
  //         <title>Home</title>
  //     </Helmet>
  //   </IonHeader>
  //   <IonContent>
  //   </IonContent>
  // </IonPage>
// <div className="App container">
//   <div className="five columns">
//     <h1 className="section-heading">Humans
//     <span className="white"> versus </span>Zombies</h1>
//     <h2 className="grey subheader">University of Colorado <strong className="deeporange">Boulder</strong></h2>
//     <img src="/images/skull.png" className="u-max-full-width" alt="Skull"/>
//   </div>
//   <div className="six columns lightslide-box content">
//     <h5>
//     Humans vs Zombies is a modified tag game in which students use Nerf blasters, tactics, and teamwork to survive a mock zombie apocalypse. Once tagged by a zombie player, the human becomes a zombie. The nerf equipment is used to stun and temporarily disable the oncoming zombie threat. Humans vs Zombies at CU Boulder is an organization that hold large scale events where CU students, alumni, and students from other schools can gather and survive the apocalypse together.
//     </h5>
//   </div>
// </div>
