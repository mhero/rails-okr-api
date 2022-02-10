import Tree from "react-ui-tree";
import packageJSON from "../../package.json";
import { ContextMenu, MenuItem } from "react-contextmenu";
import { StrollableContainer } from "react-stroller";
import styled from "styled-components";

const LightScrollbar = styled.div`
  width: 10px;
  background-color: #fff;
  opacity: 0.7;
  border-radius: 4px;
  margin: 10px;
`;

const OkrTree = ({
  tree,
  handleChange,
  renderNode,
  save,
  handleContextClick,
}) => (
  <div>
    <div className="tree">
      <div style={{ marginTop: "10px" }}>
        <StrollableContainer draggable bar={LightScrollbar}>
          <Tree
            paddingLeft={20}
            tree={tree}
            onChange={handleChange}
            renderNode={renderNode}
          />
        </StrollableContainer>
      </div>
    </div>
    <div className="inspector" style={{ overflow: "hidden", height: "100vh" }}>
      <StrollableContainer draggable>
        <h1>
          {packageJSON.name} {packageJSON.version}
        </h1>
        <pre>{JSON.stringify(tree, null, "  ")}</pre>
        <button onClick={save}>Save</button>
      </StrollableContainer>
    </div>

    <ContextMenu id="FILE_CONTEXT_MENU">
      <MenuItem data={{ action: "rename" }} onClick={handleContextClick}>
        Rename
      </MenuItem>
      <MenuItem data={{ action: "delete" }} onClick={handleContextClick}>
        Delete
      </MenuItem>
    </ContextMenu>
  </div>
);

export default OkrTree;
