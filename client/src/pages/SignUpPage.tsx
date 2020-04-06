import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";

interface SignUpPageProps {
}

class SignUpPage extends React.Component<SignUpPageProps> {
  constructor (props: SignUpPageProps){
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
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

  render() {
    return (
      <div className="App signup lightslide">
        <Helmet>
            <title>Signup</title>
        </Helmet>
        <div className="container">

        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(SignUpPage);
