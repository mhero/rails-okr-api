import Icon from "react-icons-kit";
import { folder } from "react-icons-kit/feather/folder";
import { file } from "react-icons-kit/feather/file";
import { folderPlus } from "react-icons-kit/feather/folderPlus";
import { filePlus } from "react-icons-kit/feather/filePlus";
import React, { Fragment } from "react";
import styled from "styled-components";

const FILE_ID = "file";
const FOLDER_ID = "folder";

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

const NodeToolbar = ({ node, isFolder, isRoot, caption, addItem }) => (
  <Toolbar>
    <FloatLeft>
      <Icon icon={isFolder ? folder : file} />
      {caption}
    </FloatLeft>
    <ToolbarFileFolder>
      <Fragment>
        {isRoot && (
          <Icon
            title="New OKR"
            icon={folderPlus}
            onClick={() => addItem(FOLDER_ID, node)}
          />
        )}
        {!isRoot && isFolder && (
          <Icon
            title="New Goal"
            icon={filePlus}
            onClick={() => addItem(FILE_ID, node)}
          />
        )}
      </Fragment>
    </ToolbarFileFolder>
  </Toolbar>
);

export default NodeToolbar;
