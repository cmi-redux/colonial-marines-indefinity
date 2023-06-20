import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Divider, Collapsible, Box } from '../components';
import { Window } from '../layouts';

export const Who = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    admin,
    all_clients,
    total_players,
    additional_info,
    factions,
    xenomorphs,
  } = data;

  return (
    <Window resizable width={600} height={600}>
      <Window.Content scrollable>
        {total_players !== undefined && (
          <Fragment>
            <WhoCollapsible title="Players">
              <Box direction="column">
                {total_players.map((x, index) => (
                  <Box key={x.index} direction="row">
                    <a color={x.ckey_color}>{x.ckey}</a>
                    {admin && (
                      <a>
                        <GetPlayerInfo
                          mob_state={x.mob_state}
                          mob_type={x.mob_type}
                          mob_name={x.mob_name}
                          observer_state={x.observer_state}
                          mob_state_color={x.mob_state_color}
                          color_mob_state={x.color_mob_state}
                          mob_type_name={x.mob_type_name}
                        />
                        <Button
                          color="red"
                          content="?"
                          onClick={() =>
                            act('get_player_panel', { ckey: x.ckey })
                          }
                        />
                      </a>
                    )}
                  </Box>
                ))}
              </Box>
            </WhoCollapsible>
            <Divider />
          </Fragment>
        )}
        {all_clients !== undefined && (
          <Fragment>
            <Box>Total Players: {all_clients}</Box>
            <Divider />
          </Fragment>
        )}
        {admin && (
          <Fragment>
            {additional_info !== undefined && (
              <WhoCollapsible title="Information">
                <Box direction="column">
                  {additional_info.lobby !== undefined && (
                    <Box color="#777">in Lobby: {additional_info.lobby}</Box>
                  )}
                  <Box direction="row">
                    {additional_info.observers !== undefined && (
                      <a color="#777">
                        Spectators: {additional_info.observers} Players
                      </a>
                    )}
                    {additional_info.admin_observers !== undefined && (
                      <a color="#777">
                        {' '}
                        and {additional_info.admin_observers} Administrators
                      </a>
                    )}
                  </Box>
                  <Box direction="row">
                    {additional_info.humans !== undefined && (
                      <a color="#2C7EFF">Humans: {additional_info.humans}</a>
                    )}
                    {additional_info.infected_humans !== undefined && (
                      <a color="#F00">
                        {' '}
                        (Infected: {additional_info.infected_humans})
                      </a>
                    )}
                  </Box>
                  <Box direction="row">
                    {additional_info.uscm !== undefined && (
                      <a color="#7ABA19">
                        USS `Almayer` Personnel: {additional_info.uscm}
                      </a>
                    )}
                    {additional_info.uscm_marines !== undefined && (
                      <a color="#7ABA19">
                        {' '}
                        (Marines: {additional_info.uscm_marines})
                      </a>
                    )}
                  </Box>
                  <Box direction="row">
                    {additional_info.yautja !== undefined && (
                      <a color="#7ABA19">Yautjes: {additional_info.yautja}</a>
                    )}
                    {additional_info.infected_preds !== undefined && (
                      <a color="#7ABA19">
                        {' '}
                        (Infected: {additional_info.infected_preds})
                      </a>
                    )}
                  </Box>
                  {factions !== undefined && (
                    <Box>
                      {factions.map((x, index) => (
                        <Box key={x.index}>
                          <Box color={x.color}>
                            {x.name}: {x.value}
                          </Box>
                        </Box>
                      ))}
                    </Box>
                  )}
                  {xenomorphs !== undefined && (
                    <Box>
                      {xenomorphs.map((x, index) => (
                        <Box key={x.index}>
                          <Box color={x.color}>
                            {x.name}: {x.value}
                            <a color={x.queen_color}>({x.queen})</a>
                          </Box>
                        </Box>
                      ))}
                    </Box>
                  )}
                </Box>
              </WhoCollapsible>
            )}
            <Divider />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const WhoCollapsible = (props, context) => {
  const { title, children } = props;
  return (
    <Collapsible title={title} open>
      {children}
    </Collapsible>
  );
};

const GetPlayerInfo = (props, context) => {
  const {
    mob_state,
    mob_type,
    mob_name,
    observer_state,
    mob_state_color,
    color_mob_state,
    mob_type_name,
  } = props;

  switch (mob_type) {
    case 'new_player':
      return <a> - in Lobby</a>;
    case 'observer':
      return (
        <a>
          {' '}
          - Playing as {mob_name} -
          <a color={mob_state_color}> {observer_state}</a>
        </a>
      );
    case 'mob':
      return (
        <a>
          {' '}
          - Playing as {mob_name}
          {mob_state !== 'Alive' && (
            <a>
              {' '}
              - <a color={color_mob_state}>{mob_state}</a>
            </a>
          )}
          {mob_type_name !== undefined && (
            <a>
              {' '}
              - <a color={mob_state_color}>{mob_type_name}</a>
            </a>
          )}
        </a>
      );
  }
};
