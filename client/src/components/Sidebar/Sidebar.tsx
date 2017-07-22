import * as React from 'react';
import * as classnames from 'classnames';
import {Link} from 'react-router-dom';

import * as styled from 'styled-components';

interface Props {
  className: string;
  items: any[];
  topItems: any[];
  bottomItems: any[];
  location: any;
}

const SidebarLink: React.SFC = ({to, id, label, location}) =>
  <Link
    className={classnames('item', {
      active: location.pathname === to
    })}
    to={to}
    key={id}
  >
    {label}
  </Link>;

export const Sidebar: React.SFC<Props> = ({
  className,
  topItems,
  bottomItems,
  location
}) => {
  console.log(location);
  return (
    <div className={className}>
      <section>
        {topItems &&
          topItems.map(item => {
            return <SidebarLink {...item} location={location} />;
          })}
      </section>
      <section>
        {bottomItems &&
          bottomItems.map(item => {
            return <SidebarLink {...item} location={location} />;
          })}
      </section>
    </div>
  );
};

export default styled(Sidebar)`
display: flex;
flex-direction: column;
width: ${props => props.theme.sidebarWidth};

section {
  flex: 1;
}
.item {
  display: block;
  padding: 20px 0;
  margin: 10px 0;
  color: ${props => props.theme.dark};
  &.active {
    text-decoration: underline;
  }
  i {
    width: 45px;
    height: 45px;
  }
}
`;
