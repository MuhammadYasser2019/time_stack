import React from "react";
import {set_up_axios} from "../helpers/requestHelper";

class BaseComponent extends React.Component {
  constructor(props){
      set_up_axios();
      super(props);
  }
}

export default BaseComponent
