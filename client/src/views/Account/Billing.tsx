import * as React from 'react';

import styled from 'styled-components';

import AccountLayout from './AccountLayout';

interface Props {}

export const Billing: React.SFC<Props> = props => {
  return <div>Billing goes here</div>;
};

export default AccountLayout(Billing);
