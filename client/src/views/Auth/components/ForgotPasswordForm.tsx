import * as React from "react";
import * as classnames from "classnames";

import { Form, FormGroup, Submit } from "../../../../components/Form";

export class LoginForm extends React.Component {
  loginSubmit = fields => {
    console.log("Form ->", fields);
  };
  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
          <FormGroup
            field={"email"}
            type="email"
            className="col-xs-12"
            label={"Email"}
          />
        <div className="submit">
          <Submit type="submit" value="Login" className="col-xs-12" />
        </div>
      </Form>
    );
  }
}

export default LoginForm;
