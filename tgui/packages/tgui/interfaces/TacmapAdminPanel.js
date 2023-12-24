import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Button, Stack, Flex } from '../components';
import { DrawnMap } from './DrawnMap';
import { Window } from '../layouts';

export const TacmapAdminPanel = (props, context) => {
  const { data } = useBackend(context);
  const {
    faction_ckeys,
    faction_names,
    faction_times,
    faction_map,
    faction_svg,
    faction_selection,
    faction_selected,
    last_update_time,
    factions,
    faction_name,
    max_zlevel,
  } = data;

  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', faction_selected);

  return (
    <Window
      width={600}
      height={800}
      theme='ntos'
      resizable>
      <Window.Content scrollable>
        <Stack direction="column" fill>
          <Stack.Item basis="content" grow={0} pb={1}>
            <Tabs>
              {factions.map((page, i) => {
                if (page.canAccess && !page.canAccess(data)) {
                  return;
                }

                return (
                  <Tabs.Tab
                    key={i}
                    color={page.color}
                    selected={i === pageIndex}
                    icon={page.icon}
                    onClick={() => setPageIndex(i)}>
                    {page.title}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
          <Stack.Item mx={0} basis="content">
            <FactionPage
              faction_name={faction_name}
              svg={faction_ckeys}
              ckeys={faction_names}
              names={faction_times}
              times={faction_map}
              selected_map={faction_selection}
            />
          </Stack.Item>
          <Stack.Item mx={0} grow={0}>
            <div justify="center" align="center" fontSize="30px">
              <DrawnMap
                key={last_update_time + pageIndex}
                svgData={faction_svg}
                flatImage={faction_map}
              />
            </div>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const FactionPage = (props, context) => {
  const { act } = useBackend(context);
  const { faction_name, svg, ckeys, names, times, selected_map } = props;

  return (
    <Section
      title={faction_name}
      buttons={
        <Button
          icon="fa-solid fa-download"
          content="Fix Cache"
          tooltip="Attempt to send flat tacmap data for the current selection. Use this if the map is incorrectly a wiki map."
          tooltipPosition="bottom"
          ml={0.5}
          onClick={() =>
            act('recache', {})
          }
        />
      }>
      {Object(ckeys).map((ckey, ckey_index) => (
        <Flex
          direction="row"
          key={ckey_index}
          backgroundColor={ckey_index % 2 === 1 ? 'rgba(255,255,255,0.1)' : ''}>
          <Flex.Item grow={0} basis="content" mx={0.5} mt={0.8}>
            <Button.Checkbox
              content="View"
              textAlign="center"
              verticalAlignContent="bottom"
              checked={selected_map === ckey_index}
              disabled={selected_map === ckey_index}
              onClick={() =>
                act('change_selection', {
                  index: ckey_index,
                })
              }
            />
          </Flex.Item>
          <Flex.Item grow={1} align="center" m={1} p={0.2}>
            {names[ckey_index]} ({ckey}) - {times[ckey_index]}
          </Flex.Item>
          <Flex.Item grow={0} basis="content" mr={0.5} mt={0.8}>
            <Button.Confirm
              icon="trash"
              color="white"
              confirmColor="bad"
              content="Delete"
              textAlign="center"
              verticalAlignContent="bottom"
              width={6.5}
              disabled={selected_map !== ckey_index || svg === null}
              onClick={() =>
                act('delete', {
                  uscm: is_uscm,
                  index: ckey_index,
                })
              }
            />
          </Flex.Item>
        </Flex>
      ))}
    </Section>
  );
};
