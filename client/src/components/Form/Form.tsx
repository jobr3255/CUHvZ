import React, { FormEvent } from 'react';

interface FormProps {
  onSubmit: (data: { [key: string]: string | number }) => void;
}

export default class Form extends React.Component<FormProps> {
  constructor(props: any) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e: FormEvent) {
    e.preventDefault();
    var form = (e.target as HTMLElement);
    var inputs = form.getElementsByTagName("input");
    var element;
    var data: { [key: string]: string | number } = {};
    for (let i = 0; i < inputs.length; ++i) {
      element = (inputs[i] as HTMLInputElement);
      data[element.name] = element.value;
    }
    this.props.onSubmit(data);
  }

  render() {
    return (
      <form onSubmit={e => this.handleSubmit(e)} action="post" >
        {this.props.children}
      </form>
    );
  }
}
