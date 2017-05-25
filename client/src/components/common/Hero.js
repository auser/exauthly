import React, { Component } from 'react'
import {
  Grid,
} from 'react-bootstrap';

import classnames from 'classnames'

export const Hero = props => (
  <div
    {...props}
    className={classnames(props.className, 'homepage-hero')}>
      <Grid>
        {props.children}
      </Grid>
  </div>
)

export default Hero