import { withIonLifeCycle } from '@ionic/react';
import React, { useState, FormEvent, ChangeEvent } from 'react';
import Form from "../components/Form/Form";

class Login extends React.Component {
  constructor(props: any) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(data: any) {
    console.log(data);
    // for (let key in data) {
    //     let value = data[key];
    //     console.log(key + ": " + value);
    // }
  }

  render() {
    return (
      <Form onSubmit={this.handleSubmit} >
        <label>Username</label>
        <input
          placeholder="Username"
          name="username"></input>
          <div>
            <input
              name="password"></input>
          </div>
        <button type="submit">Log in</button>
      </Form>
    );
  }
}

export default withIonLifeCycle(Login);
