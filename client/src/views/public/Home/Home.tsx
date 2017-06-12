import * as React from "react";
import * as classnames from "classnames";

import "./Home.scss";
import CoreLayout from "../../../layouts/CoreLayout";
import styled from "styled-components";

import Hero from './components/Hero'
import Features from './components/Features'
import CTA from './components/CallToAction'
import Footer from './components/Footer'

const HomeView = props =>
  <div>
    <div className={classnames("text-center", props.className)}>
      <div className="">
        <Hero />
        <Features />
        <CTA />
        <Footer />
      </div>
    </div>
  </div>;

export const Home = CoreLayout(HomeView);

export default Home;
