import * as React from 'react';

import SidebarLayout from '../../layouts/SidebarLayout';

interface Props {}

export const AccountLayout = Wrapped => {
  const AccountLayoutWrapper = props => <Wrapped {...props} />;

  return SidebarLayout(AccountLayoutWrapper);
};

export default AccountLayout;
