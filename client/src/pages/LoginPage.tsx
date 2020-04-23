import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import Form from "../components/Form/Form";
import LoginController from "../controllers/LoginController";

/**
 * LoginPage state variables
 */
interface LoginPageStates {
  error: string | null
}

/**
 * LoginPage component
 */
class LoginPage extends React.Component<any, LoginPageStates> {
  constructor(props: any) {
    super(props);
    this.state = {
      error: null
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  /**
   * Handles the form submission
   */
  async handleSubmit(data: any) {
    var controller = new LoginController();
    var userLogin = await controller.login(data["user"], data["password"]);
    if(userLogin){
      if(userLogin["error"]){
        this.setState({
          error: userLogin["error"]
        });
      }else{
        this.props.login(userLogin, data["password"]);
      }
    }else{
      this.setState({
        error: "Unknown error occured"
      });
    }
  }

  render() {
    var errorMsg;
    if(this.state.error){
      errorMsg = <p className="bg-danger">{this.state.error}</p>
    }
    return (
      <div className="container">
        <div className="login-form lightslide-box" >
          <h4 className="white">Please login.</h4>
          <hr />
          <p>Not a member? <a href='/signup'>Sign-up now.</a></p>

          <Form onSubmit={this.handleSubmit} >
            {errorMsg}

            <div className="form-group">
              <label>Username/Email</label>
              <input type="text" name="user" placeholder="Username/Email" required></input>
            </div>

            <div className="form-group">
              <label>Password</label>
              <input type="password" name="password" placeholder="Password" required autoComplete="new-password"></input>
            </div>

            <div style={{ float: "left", width: "100%" }}>
              <a href='reset.php'>Forgot Password?</a>
            </div>

            <button type="submit" name="submit" className="btn btn-primary btn-block btn-lg button-primary">Login</button>
          </Form>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(LoginPage);
