import * as React from 'react';

import styled from 'styled-components';

import AccountLayout from './AccountLayout';

interface Props {}

export const Logout: React.SFC<Props> = props => {
  return <div>Logout goes here</div>;
};

export default AccountLayout(Logout);
