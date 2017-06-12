import * as React from "react";
import * as classnames from "classnames";

import styled from "../../../../../styles/styled-components";

export const Products = (props:any) => {
  return (
    <div className={props.className}>
      Products
    </div>
  )
}

export const ProductsView = styled(Products)`
background-color: ${props => props.theme.bg}
`;

export default ProductsView
