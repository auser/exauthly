import * as React from "react";
import * as classnames from "classnames";

import styled from "styled-components";
import hello from '../../../../../lib/hello'

export class Products extends React.Component {

  // async componentDidMount() {
  //   const products = await hello('gumroad').api('/v2/products')
  //   console.log(products)
  // }

  render() {
    return (
      <div className={this.props.className}>
        Products
      </div>
    )
  }
}

export const ProductsView = styled(Products)`
background-color: ${props => props.theme.bg}
`;

export default ProductsView
