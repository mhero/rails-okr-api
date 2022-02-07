import "./App.css";

import React, { Component, Fragment } from "react";
import Tree from "react-ui-tree";
import initialTree from "./tree";
import packageJSON from "../package.json";
import Icon from "react-icons-kit";
import { folder } from "react-icons-kit/feather/folder";
import { file } from "react-icons-kit/feather/file";
import { folderPlus } from "react-icons-kit/feather/folderPlus";
import { filePlus } from "react-icons-kit/feather/filePlus";
import styled from "styled-components";
import { ContextMenu, MenuItem, ContextMenuTrigger } from "react-contextmenu";
import _ from "lodash";
import { StrollableContainer } from "react-stroller";
import deepdash from "deepdash";

import "./styles.css";
import "react-ui-tree/dist/react-ui-tree.css";
import "./theme.css";
import "./react-contextmenu.css";
import postOkrTree from "./Middleware";

// add deepdash to lodash
deepdash(_);

const FOLDER_ID = "folder";
const FILE_ID = "file";
const CHILDREN_ID = "children";

const LightScrollbar = styled.div`
  width: 10px;
  background-color: #fff;
  opacity: 0.7;
  border-radius: 4px;
  margin: 10px;
`;
const Toolbar = styled.div`
  position: relative;
  display: flex;
  color: #d8e0f0;
  z-index: +1;
  /*border: 1px solid white;*/
  padding-bottom: 4px;
  i {
    margin-right: 5px;
    cursor: pointer;
  }
  i :hover {
    color: #d8e0f0;
  }
`;

const FloatLeft = styled.span`
  padding-left: 4px;
  width: 100%;
`;

const ToolbarFileFolder = styled.div`
  position: absolute;
  text-align: right;
  width: 92%;
  color: transparent;
  &:hover {
    color: #d8e0f0;
  }
`;

const initialState = {
  active: null,
  tree: {
    ...initialTree,
  },
  collapsed: false, // start with unmodified tree
};
class App extends Component {
  state = initialState;

  collect = (props) => {
    return props;
  };

  deleteItem = (tree, id) => {
    function getNode(node, i) {
      if (node.id === id) {
        index = i;
        return true;
      }
      if (Array.isArray(node.children) && node.children.some(getNode)) {
        if (~index) {
          node.children.splice(index, 1);
          index = -1;
        }
        return true;
      }
    }

    let index = -1;
    [tree].some(getNode);
  };

  newItem = (itemType) => {
    const item =
      itemType === FOLDER_ID
        ? {
            id: `root-${Date.now()}`,
            title: `New ${itemType}`,
            children: [],
            collapsed: false,
          }
        : {
            id: `${Date.now()}`,
            leaf: true,
            title: `New ${itemType}`,
          };
    return item;
  };

  addItem = (itemType, active) => {
    const { tree } = this.state;
    const newItem = this.newItem(itemType);

    const newTree = _.mapDeep(tree, (item) => {
      const cloneItem = Object.assign({}, item);
      if (cloneItem) {
        if (cloneItem.id === active.id && cloneItem.children) {
          cloneItem.children.push(newItem);
        }
      }
      return cloneItem;
    });

    this.setState({ ...newTree });
  };

  renderNode = (node) => {
    const renderFileFolderToolbar = (isFolder, caption) => (
      <Toolbar>
        <FloatLeft>
          <Icon icon={isFolder ? folder : file} />
          {caption}
        </FloatLeft>
        <ToolbarFileFolder>
          {isFolder && (
            <Fragment>
              <Icon
                title="New OKR"
                icon={folderPlus}
                onClick={() => this.addItem(FOLDER_ID, node)}
              />
              <Icon
                title="New Goal"
                icon={filePlus}
                onClick={() => this.addItem(FILE_ID, node)}
              />
            </Fragment>
          )}
        </ToolbarFileFolder>
      </Toolbar>
    );

    const isFolder = node.hasOwnProperty(CHILDREN_ID);

    return (
      <ContextMenuTrigger
        id="FILE_CONTEXT_MENU"
        key={node.id}
        name={node.id}
        collect={this.collect}
        holdToDisplay={-1}
        onItemClick={this.handleContextClick}
      >
        {renderFileFolderToolbar(isFolder, node.title)}
      </ContextMenuTrigger>
    );
  };

  handleContextClick = (e, { action, name: id }) => {
    const { tree } = this.state;

    switch (action) {
      case "rename":
        const renameObj = _.findDeep(tree, (item) => item.id === id, {
          childrenPath: CHILDREN_ID,
        });
        const response = prompt("Please rename", renameObj.value.title);

        if (response === "") {
          return;
        }
        renameObj.value.title = response;
        this.setState(
          _.mapDeep(
            tree,
            (item) =>
              item.id === id
                ? {
                    ...item,
                    ...renameObj.value,
                  }
                : item,
            { childrenPath: CHILDREN_ID }
          )
        );
        break;
      case "delete":
        this.deleteItem(tree, id);
        this.setState({
          tree,
        });
        break;
      default:
    }
  };

  handleChange = (tree) => {
    postOkrTree(tree);
    this.setState({
      tree: tree,
    });
  };

  render() {
    return (
      <div>
        <div className="tree">
          <div style={{ marginTop: "10px" }}>
            <StrollableContainer draggable bar={LightScrollbar}>
              <Tree
                paddingLeft={20}
                tree={this.state.tree}
                onChange={this.handleChange}
                renderNode={this.renderNode}
              />
            </StrollableContainer>
          </div>
        </div>
        <div
          className="inspector"
          style={{ overflow: "hidden", height: "100vh" }}
        >
          <StrollableContainer draggable>
            <h1>
              {packageJSON.name} {packageJSON.version}
            </h1>
            <pre>{JSON.stringify(this.state.tree, null, "  ")}</pre>
          </StrollableContainer>
        </div>

        <ContextMenu id="FILE_CONTEXT_MENU">
          <MenuItem
            data={{ action: "rename" }}
            onClick={this.handleContextClick}
          >
            Rename
          </MenuItem>
          <MenuItem
            data={{ action: "delete" }}
            onClick={this.handleContextClick}
          >
            Delete
          </MenuItem>
        </ContextMenu>
      </div>
    );
  }
}

export default App;
