import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import SignUpController from "../controllers/SignUpController";

/**
 * LoginPage state variables
 */
interface SignUpPageStates {
  usernames: string[],
  emails: string[]
}
/**
 * SignUpPage component
 */
class SignUpPage extends React.Component<any, SignUpPageStates> {
  constructor (props: any){
    super(props);
    this.state = {
      usernames: [],
      emails: []
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.validateUsername = this.validateUsername.bind(this);
  }

  getFormData(event: any){
    var elements = event.target.elements;
    var data = {};
    for (var element of elements){
      if(element.tagName === "INPUT"){
        // data[element.name] = element.value;
      }
    }
    return data;
  }

  handleSubmit(event: any) {
    event.preventDefault();
    // const data = JSON.stringify(this.getFormData(event));
    // const url = 'http://localhost:9000/testpost';
    // const options = {
    //   method: 'POST',
    //   headers: { 'content-type': 'application/json' },
    //   data,
    //   url,
    // };
    // axios(options)
    // .then(function (response) {
    //   console.log(response);
    // })
    // .catch(function (error) {
    //   console.log(error);
    // });
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    var controller = new SignUpController();
    var userData = await controller.getUsersList();
    var usernames = [];
    var emails = [];
    for (var data of userData) {
      usernames.push(data["username"]);
      emails.push(data["email"]);
    }
    this.setState({
      emails: emails,
      usernames: usernames
    });
  }

  validateUsername(e: any) {
    var element = (e.target as HTMLElement);
    console.log(element);
  }

  render() {
    return (
      <div className="container">
        <Helmet>
            <title>Signup</title>
        </Helmet>
        <div className="content lightslide-box white">

        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(SignUpPage);
 // onBlur={this.validateUsername}
