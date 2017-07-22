import * as React from 'react';

import styled from 'styled-components';

import SidebarLayout from '../../layouts/SidebarLayout';
import AccountLayout from './AccountLayout';

interface Props {}

export const Profile: React.SFC<Props> = props => {
  return <div>Profile goes here</div>;
};

export default AccountLayout(Profile);
