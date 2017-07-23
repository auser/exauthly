import * as React from 'react';

import styled from 'styled-components';

import Sidebar from '../components/Sidebar/Sidebar';

interface Props {
  className: string;
}

const items = [
  {id: 1, label: 'Profile', to: '/account'},
  {id: 2, label: 'Billing', to: '/account/billing'},
  {id: 3, label: 'Organizations', to: '/account/organizations'}
];

export const SidebarLayout = (Wrapped: React.SFC<Props>) => {
  const SidebarWrapper = props => {
    return (
      <div className={props.className}>
        <div className="page-content">
          <div className="container-fluid">
            <div className="row">
              <div className="col-sm-4" id="left">
                <Sidebar items={items} {...props} />
              </div>
              <div className="col-sm-8" id="right">
                <div className="row">
                  <Wrapped {...props} />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  return styled(SidebarWrapper)`

  @media (min-width: ${props => props.theme.smallScreen}){
    #left {
      position: absolute;
      top: 0px;
      bottom: 0;
      left: 0;
      width: ${props => props.theme.sidebarWidth};
      overflow-y: scroll;
    }

    #right {
      position: absolute;
      top: 0;
      bottom: 0;
      right: 0;
      overflow-y: scroll;
      width: calc(100% - ${props => props.theme.sidebarWidth});
    }
  }

  #left {
    background-color: #FFFFFF;
    height:100%;
  }

  #right {
    height:100%;
    background-color: ${props => props.theme.softGrey};
  }
  `;
};

export default SidebarLayout;
