import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import SignUpController from "../controllers/SignUpController";
import Form from "../components/Form/Form";

/**
 * LoginPage state variables
 */
interface SignUpPageProps {
  login: any
}

/**
 * LoginPage state variables
 */
interface SignUpPageStates {
  usernames: string[] | null,
  emails: string[] | null,
  phones: string[] | null,
  error: string | null,
  usernameError: string | null,
  emailError: string | null,
  passwordError: string | null,
  phoneError: string | null,
  nameError: string | null,
  password: string
}

/**
 * SignUpPage component
 */
class SignUpPage extends React.Component<SignUpPageProps, SignUpPageStates> {
  constructor(props: any) {
    super(props);
    this.state = {
      usernames: null,
      emails: null,
      phones: null,
      error: null,
      usernameError: null,
      emailError: null,
      passwordError: null,
      phoneError: null,
      nameError: null,
      password: ""
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.validateUsername = this.validateUsername.bind(this);
    this.validateEmail = this.validateEmail.bind(this);
    this.validatePhone = this.validatePhone.bind(this);
    this.validatePassword = this.validatePassword.bind(this);
    this.validateName = this.validateName.bind(this);
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    var controller = new SignUpController();
    var userData = await controller.getUsersList();
    if (userData) {
      var usernames: any[] | null = [];
      var emails: any[] | null = [];
      var phones: any[] | null = [];
      for (var data of userData) {
        usernames.push(data["username"]);
        emails.push(data["email"]);
        phones.push(data["phone"]);
      }
      this.setState({
        emails: emails,
        usernames: usernames,
        phones: phones,
        error: null
      });
    } else {
      this.setState({
        error: "Error connecting to server"
      });
    }
  }

  /**
   * Handles the form submission
   */
  async handleSubmit(data: any) {
    var controller = new SignUpController();
    var validForm = !(this.state.error || this.state.usernameError || this.state.emailError || this.state.passwordError || this.state.phoneError || this.state.nameError) && this.state.password;
    if(validForm){
      var result = await controller.createUser(data);
      if(result){
        if(result["error"]){
          this.setState({
            error: result["error"]
          });
        }else{
          this.props.login(result, data["password"]);
        }
      }else{
        this.setState({
          error: "Unknown error occured"
        });
      }
    }

  }


  /**
   * Validates the users entered username. Sets usernameError if username does not validate
   */
  validateUsername(e: any) {
    var element = (e.target as HTMLInputElement);
    // Trim any whitespace
    var username = element.value;
    if (this.state.usernames == null) {
      this.setState({
        usernameError: "Username validation error."
      });
      return;
    } else {
      // Validate length
      if (username.length < 3) {
        this.setState({
          usernameError: "Username must be 3 characters or longer"
        });
        return;
      }
      if (username.length > 30) {
        this.setState({
          usernameError: "Username must be 30 characters or shorter"
        });
        return;
      }
      if(username.indexOf(' ') >= 0){
        this.setState({
          usernameError: "Username cannot contain spaces"
        });
        return;
      }
      var inList = this.state.usernames.indexOf(username);
      if(inList >= 0){
        this.setState({
          usernameError: "Username already taken."
        });
        return;
      }
    }
    this.setState({
      usernameError: null
    });
  }


  /**
   * Validates the users entered email. Sets emailError if email does not validate
   */
  validateEmail(e: any) {
    var element = (e.target as HTMLInputElement);
    var email = element.value.trim();
    if (this.state.emails == null) {
      this.setState({
        emailError: "Email validation error."
      });
      return;
    } else {
      if (email.length === 0) {
        this.setState({
          emailError: "Email is blank"
        });
        return;
      }
      var inList = this.state.emails.indexOf(email);
      if(inList >= 0){
        this.setState({
          emailError: "Email already taken."
        });
        return;
      }
    }
    this.setState({
      emailError: null
    });
  }

  validatePassword(e: any){
    var element = (e.target as HTMLInputElement);
    var pass = element.value.trim();
    if(element.name === "passwordConfirm"){
      if(this.state.password !== pass){
        this.setState({
          passwordError: "Passwords do not match"
        });
        return;
      }
    }
    if (pass.length < 8) {
      this.setState({
        passwordError: "Password must be 8 characters or longer"
      });
      return;
    }
    if(element.name === "password"){
      this.setState({
        passwordError: null,
        password: pass
      });
    }else{
      this.setState({
        passwordError: null
      });
    }
  }

  validatePhone(e: any){
    var element = (e.target as HTMLInputElement);
    var phone = element.value.trim();
    if(phone){
      if(this.state.phones){
        // Phone number validation regex came from http://zparacha.com/phone_number_javascript_regex
        var phoneNumberPattern = /^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/;
        if(!phoneNumberPattern.test(phone)){
          this.setState({
            phoneError: "Phone number invalid."
          });
          return;
        }
        var inList = this.state.phones.indexOf(phone);
        if(inList >= 0){
          this.setState({
            phoneError: "Phone number is already in use."
          });
          return;
        }
      }
    }
    this.setState({
      phoneError: null
    });
  }

  validateName(e: any){
    var element = (e.target as HTMLInputElement);
    var name = element.value.trim();
    if(name){
      if(/\d/.test(name)){
        this.setState({
          nameError: "Name cannont contain numbers"
        });
        return;
      }
    }else{
      this.setState({
        nameError: "Name cannot be blank."
      });
      return;
    }
    this.setState({
      nameError: null
    });
  }

  render() {
    var errorMsg, usernameMsg, emailMsg, phoneMsg, nameMsg, passMsg;
    if (this.state.error) {
      errorMsg = <p className="error">{this.state.error}</p>;
    }
    if (this.state.usernameError) {
      usernameMsg = <p className="error">{this.state.usernameError}</p>;
    }
    if (this.state.emailError) {
      emailMsg = <p className="error">{this.state.emailError}</p>;
    }
    if (this.state.phoneError) {
      phoneMsg = <p className="error">{this.state.phoneError}</p>;
    }
    if (this.state.passwordError) {
      passMsg = <p className="error">{this.state.passwordError}</p>;
    }
    if (this.state.nameError) {
      nameMsg = <p className="error">{this.state.nameError}</p>;
    }
    var submitButton = <button type="submit" name="submit" className="btn btn-primary btn-block btn-lg button-primary">Submit</button>;
    if(errorMsg || usernameMsg || emailMsg || phoneMsg || nameMsg || passMsg){
      submitButton = <button type="submit" name="submit" className="btn btn-primary btn-block btn-lg button-primary" disabled>Submit</button>;
    }
    return (
      <div className="container">
        <Helmet>
          <title>Signup</title>
        </Helmet>
        <div className="five columns hide-mobile">
          <h1 className="section-heading">Humans
          <span className="white"> versus </span>Zombies</h1>
          <h2 className="grey subheader">University of Colorado <strong className="deeporange">Boulder</strong></h2>
          <img src="/images/skull.png" className="u-max-full-width" alt="Skull" />
        </div>
        <div className="six columns lightslide-box content signup-form">
          <h4 className="white">Register to play.</h4>
          <hr />
          <p>Already registered? <a href='/login'>Login.</a></p>

          <Form onSubmit={this.handleSubmit}>
            {errorMsg}

            <div className="twelve columns">
              {usernameMsg}
              <label className="small">Username (3-30 characters)</label>
              <input type="text" name="username" className="form-control input-lg u-full-width" placeholder="Username" autoComplete="off" required onChange={this.validateUsername} />
              {emailMsg}
              <label className="small">Email</label>
              <input type="email" name="email" className="form-control input-lg u-full-width" placeholder="Email Address" autoComplete="email" required onChange={this.validateEmail} />
              {phoneMsg}
              <label className="small">Phone (optional)</label>
              <input type="text" name="phone" className="form-control input-lg u-full-width" placeholder="Phone Number" autoComplete="tel" onChange={this.validatePhone} />
            </div>

            <div className="twelve columns">
              {nameMsg}
            </div>
            <div className="row">
              <div className="six columns">
                <label className="small">First Name</label>
                <input type="text" name="firstName" className="form-control input-lg u-full-width" placeholder="First Name" autoComplete="name" required onChange={this.validateName} />
              </div>
              <div className="six columns">
                <label className="small">Last Name</label>
                <input type="text" name="lastName" className="form-control input-lg u-full-width" placeholder="Last Name" autoComplete="name" required onChange={this.validateName} />
              </div>
            </div>

            <div className="twelve columns">
              {passMsg}
            </div>
            <label className="small">Password (Min 8 characters)</label>
            <div className="row">
              <div className="six columns">
                <input type="password" name="password" className="form-control input-lg u-full-width" placeholder="Password" autoComplete="new-password" onChange={this.validatePassword} required />
              </div>
              <div className="six columns">
                <input type="password" name="passwordConfirm" className="u-full-width form-control input-lg" placeholder="Confirm" onChange={this.validatePassword} autoComplete="new-password" required />
              </div>
            </div>

            <div className="row">
              <div className="twelve columns">
                {submitButton}
              </div>
            </div>

          </Form>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(SignUpPage);
