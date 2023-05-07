import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Box, NanoMap, Stack } from '../components';
import { Window } from '../layouts';

/**
 * Marker selector.
 *
 * Filters markers, applies search terms and sorts the alphabetically.
 */
const selectMarkers = (markers, searchText = '') => {
  const testSearch = createSearch(searchText, (marker) => marker.name);
  return flow([
    // Null marker filter
    filter((marker) => marker?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy((marker) => marker.name),
  ])(markers);
};

export const Minimap = (props, context) => {
  const { data } = useBackend(context);
  const markers = selectMarkers(data.markers);
  const { map_name } = data;

  return (
    <Window
      width={1000}
      height={1000}
    >
      <Window.Content id="minimap">
        <Stack justify="space-around">
          <Stack.Item>
            <Box
              className="Minimap__Map"
              style={{
                'background-image': `url('minimap.${map_name}.png')`,
                'background-repeat': "no-repeat",
              }}
              onClick={() => setSelectedName(null)}
            >
              <NanoMap onZoom={(v) => setZoom(v)}>
                {markers
                  .map((cm) => (
                    <NanoMap.NanoButton
                      activeMarker={activeMarker}
                      key={cm.ref}
                      x={cm.x}
                      y={cm.y}
                      context={context}
                      zoom={zoom}
                      icon="circle"
                      tooltip={cm.name}
                      name={cm.name}
                      color={cm.color}
                    />
                  ))}
              </NanoMap>
            </Box>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const Map = (props, context) => {
  const { data } = useBackend(context);
  const { map_name } = data;

  const [isScrolling, setScrolling] = useLocalState(context, "is_scrolling", false);

  const [lastMousePos, setLastMousePos] = useLocalState(context, "last_mouse_pos", null);

  const startDragging = e => {
    setLastMousePos(null);
    setScrolling(true);
  };

  const stopDragging = e => {
    setScrolling(false);
  };

  const doDrag = e => {
    if (isScrolling) {
      const { screenX, screenY } = e;
      const element = document.getElementById("minimap");
      if (lastMousePos) {
        element.scrollLeft = element.scrollLeft + lastMousePos[0] - screenX;
        element.scrollTop = element.scrollTop + lastMousePos[1] - screenY;
      }
      setLastMousePos([screenX, screenY]);
    }
  };

  return (
    <Window
      width={1000}
      height={1000}
    >
      <Window.Content id="minimap">
        <div
          style={{
            'background-image': `url('minimap.${map_name}.png')`,
            'background-repeat': "no-repeat",
          }}
          onMouseDown={startDragging}
          onMouseUp={stopDragging}
          onMouseMove={doDrag}
        />
      </Window.Content>
    </Window>
  );
};
