import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Divider, Collapsible, Tabs, Stack, Box } from '../components';
import { Window } from '../layouts';

export const FactionStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    faction_name,
    faction_desc,
    faction_orders,
    faction_color,
    faction_relations,
    actions,
  } = data;
  const [selectedFaction, setSelectedFaction] = useLocalState(
    context,
    'selectedFaction',
    undefined
  );

  return (
    <Window title={faction_name + ' Status'} resizable width={800} height={800}>
      <Window.Content scrollable>
        <FactionCollapsible
          title="General Faction Information"
          faction_color={faction_color}>
          <Box direction="column" align="center">
            <Box>
              <h3 className="whiteTitle">{faction_desc}</h3>
            </Box>
            <Box>
              <i>Orders: {faction_orders}</i>
            </Box>
          </Box>
        </FactionCollapsible>
        <Divider />
        <FactionCollapsible
          title="Faction Relations"
          faction_color={faction_color}>
          <FactionTabMenu
            relation={faction_relations}
            selected={selectedFaction}
            setSelected={setSelectedFaction}
          />
          {(selectedFaction !== undefined && (
            <ShowFactionCard
              selected={faction_relations[selectedFaction]}
              show_desc={1}
            />
          )) || <ShowAllFaction relation={faction_relations} />}
        </FactionCollapsible>
        <Divider />
        <FactionCollapsible
          fill
          title="Faction Tabs"
          faction_color={faction_color}>
          {actions.map((x, index) => (
            <Button
              key={x.index}
              content={x.name}
              onClick={() => act(x.action)}
            />
          ))}
        </FactionCollapsible>
        <Divider />
      </Window.Content>
    </Window>
  );
};

const FactionTabMenu = (props, context) => {
  const { relation, selected, setSelected } = props;
  return (
    <Tabs fill>
      {relation.map((x, index) => (
        <Tabs.Tab
          key={x.index}
          selected={selected === index}
          onClick={() => {
            setSelected(index);
          }}>
          {x.name}
        </Tabs.Tab>
      ))}
      <Tabs.Tab
        selected={selected === undefined}
        onClick={() => {
          setSelected(undefined);
        }}>
        All
      </Tabs.Tab>
    </Tabs>
  );
};

const GetRelationText = (props, context) => {
  const { value } = props;
  switch (value) {
    case 0:
      return <a color="dark black">ENEMY</a>;
    case 1 - 200:
      return <a color="dark red">War</a>;
    case 201 - 400:
      return <a color="red">Hostile</a>;
    case 401 - 500:
      return <a color="light red">Tense</a>;
    case 501 - 700:
      return <a color="grey">Neutral</a>;
    case 701 - 900:
      return <a color="green">Friendly</a>;
    case 901 - 1000:
      return <a color="blue">Alliance</a>;
  }
};

const ShowFactionCard = (props, context) => {
  const { selected, show_desc } = props;
  return (
    <Tabs className={classes(['SentryCard', 'SentryBox'])}>
      <a color={selected.color}>
        <Box>
          <span className="Title">{selected.name}</span>
        </Box>
        <Box height="6px" />
        {show_desc && <Box>{selected.desc}</Box>}
        <Box height="6px" />
        <Box>
          <GetRelationText value={selected.value} />
        </Box>
      </a>
    </Tabs>
  );
};

const ShowAllFaction = (props, _) => {
  const { relation } = props;
  return (
    <Stack align="space-between" wrap>
      {relation.map((x) => (
        <Stack.Item key={x.index}>
          <ShowFactionCard selected={x} show_desc={0} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const FactionCollapsible = (props, context) => {
  const { title, faction_color, children } = props;
  return (
    <Collapsible
      title={title}
      backgroundColor={!!faction_color && faction_color}
      color={!faction_color && 'white'}
      open>
      {children}
    </Collapsible>
  );
};
