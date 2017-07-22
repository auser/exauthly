import * as React from 'react';

import styled from 'styled-components';

interface Props {
  className: string;
}

export const SidebarLayout = (Wrapped: React.SFC<Props>) => {
  const SidebarWrapper = props => {
    return (
      <div className={props.className}>
        <div className="page-content">
          <div className="container-fluid">
            <div className="row">
              <div className="col-sm-4" id="left">
                <div className="">
                  <li>
                    <a href="#/milestones">Milestones --»</a>
                  </li>
                </div>
              </div>
              <div className="col-sm-8" id="right">
                <div className="panel-body">
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                  <h1>hello</h1>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  return styled(SidebarWrapper)`
  margin: 0;
  // overflow: hidden;
  height:100%;

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
    background-color: #FC6E51;
    text-align: center;
    height:100%;
  }

  #right {
    height:100%;
    background-color: #4FC1E9;
    text-align: center;
  }
  `;
};

export default SidebarLayout;
