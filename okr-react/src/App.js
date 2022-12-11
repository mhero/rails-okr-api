import "./App.css";

import React, { Component } from "react";
import { ContextMenuTrigger } from "react-contextmenu";
import _ from "lodash";
import deepdash from "deepdash";
import postOkrTree from "./request/Middleware";
import OkrTree from "./treeComponents/OkrTree";
import NodeToolbar from "./treeComponents/NodeToolbar";
import { CHILDREN_ID, ROOT_ID, INITIAL_TREE_STATE } from "./treeComponents/Constants"
import { deleteItem, renameItem, addItem } from "./treeComponents/Operations";
import "./styles.css";
import "react-ui-tree/dist/react-ui-tree.css";
import "./theme.css";
import "./react-contextmenu.css";

// add deepdash to lodash
deepdash(_);


class App extends Component {
  state = INITIAL_TREE_STATE;

  renderNode = (node) => (
    <ContextMenuTrigger
      id="FILE_CONTEXT_MENU"
      key={node.id}
      name={node.id}
      collect={() => this.props}
      holdToDisplay={-1}
      onItemClick={this.handleContextClick}
    >
      {
        <NodeToolbar
          node={node}
          isFolder={node.hasOwnProperty(CHILDREN_ID)}
          isRoot={node.id === ROOT_ID}
          caption={node.title}
          addItem={this.newItem}
        />
      }
    </ContextMenuTrigger>
  );

  newItem = (itemType, active) => {
    const { tree } = this.state;
    const newTree = addItem(tree, itemType, active, _);
    this.setState({ ...newTree });
  };

  handleContextClick = (e, { action, target }) => {
    const { tree } = this.state;
    const id = target.id || target.parentElement.children[1].id;

    if (id == null)
      return;

    switch (action) {
      case "rename":
        const renammedTree = renameItem(tree, id, _);
        this.setState(
          renammedTree,
        );
        break;
      case "delete":
        const deletedTree = deleteItem(tree, id);
        this.setState({
          tree: deletedTree,
        });
        break;
      default:
    }
  };

  handleChange = (tree) => {
    this.setState({
      tree: tree,
    });
  };

  save = () => {
    postOkrTree(this.state.tree, 1);
  };

  render() {
    return (
      <OkrTree
        tree={this.state.tree}
        handleChange={this.handleChange}
        renderNode={this.renderNode}
        save={this.save}
        handleContextClick={this.handleContextClick}
      />
    );
  }
}

export default App;
