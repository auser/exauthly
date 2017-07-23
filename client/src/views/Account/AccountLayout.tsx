import * as React from 'react';

import Navbar from '../../components/Navbar/Navbar';
import SidebarLayout from '../../layouts/SidebarLayout';

interface Props {}

export const AccountLayout = Wrapped => {
  const AccountLayoutWrapper = props => {
    return (
      <div>
        <Navbar {...props} />
        <Wrapped {...props} />
      </div>
    );
  };

  return SidebarLayout(AccountLayoutWrapper);
};

export default AccountLayout;
