import * as React from "react";
import * as classnames from "classnames";

import {
  Form, FormGroup,
  Submit
} from "../../../../components/Form";

export class LoginForm extends React.Component {
  loginSubmit = fields => {
    console.log("Form ->", fields);
  };
  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
        <div className="row">
          <FormGroup className="col-xs-12" label={"Email"} />
        </div>
        <div className="row">
          <FormGroup className="col-xs-12" label={"Password"} />
        </div>
        <div className="row">
          <div className="col-xs-12 text-center">
            <Submit
              type='submit'
              value='Login'
              className='col-xs-6'
              />
          </div>
        </div>
      </Form>
    );
  }
}

export default LoginForm;
