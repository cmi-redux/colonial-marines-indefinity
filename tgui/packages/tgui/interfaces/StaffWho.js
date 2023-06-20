import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Divider, Box } from '../components';
import { Window } from '../layouts';

export const StaffWho = (props, context) => {
  const { data } = useBackend(context);
  const { admin, manager, maintainer, administrator, moderator, mentor } = data;

  return (
    <Window resizable width={600} height={600}>
      <Window.Content scrollable>
        Administation
        <Divider />
        {manager !== undefined && (
          <Fragment>
            <Box color="purple" direction="column">
              Management: {manager.total}
              {manager.admins.map((x, index) => (
                <Box key={x.index} direction="row">
                  <a>
                    {x.ckey} is {x.rank}
                  </a>
                  {admin && (
                    <a>
                      <GetAdminInfo
                        hidden={x.hidden}
                        state={x.state}
                        state_color={x.state_color}
                        afk={x.afk}
                        afk_color={x.afk_color}
                      />
                    </a>
                  )}
                </Box>
              ))}
            </Box>
            <Divider />
          </Fragment>
        )}
        {maintainer !== undefined && (
          <Fragment>
            <Box color="blue" direction="column">
              Maintainers: {maintainer.total}
              {maintainer.admins.map((x, index) => (
                <Box key={x.index} direction="row">
                  <a>
                    {x.ckey} is {x.rank}
                  </a>
                  {admin && (
                    <a>
                      <GetAdminInfo
                        hidden={x.hidden}
                        state={x.state}
                        state_color={x.state_color}
                        afk={x.afk}
                        afk_color={x.afk_color}
                      />
                    </a>
                  )}
                </Box>
              ))}
            </Box>
            <Divider />
          </Fragment>
        )}
        <Box color="red" direction="column">
          Administrators: {administrator.total}
          {administrator.admins.map((x, index) => (
            <Box key={x.index} direction="row">
              <a>
                {x.ckey} is {x.rank}
              </a>
              {admin && (
                <a>
                  <GetAdminInfo
                    hidden={x.hidden}
                    state={x.state}
                    state_color={x.state_color}
                    afk={x.afk}
                    afk_color={x.afk_color}
                  />
                </a>
              )}
            </Box>
          ))}
        </Box>
        <Divider />
        {moderator !== undefined && (
          <Fragment>
            <Box color="orange" direction="column">
              Moderators: {moderator.total}
              {moderator.admins.map((x, index) => (
                <Box key={x.index} direction="row">
                  <a>
                    {x.ckey} is {x.rank}
                  </a>
                  {admin && (
                    <a>
                      <GetAdminInfo
                        hidden={x.hidden}
                        state={x.state}
                        state_color={x.state_color}
                        afk={x.afk}
                        afk_color={x.afk_color}
                      />
                    </a>
                  )}
                </Box>
              ))}
            </Box>
            <Divider />
          </Fragment>
        )}
        {mentor !== undefined && (
          <Fragment>
            <Box color="green" direction="column">
              Mentors: {mentor.total}
              {mentor.admins.map((x, index) => (
                <Box key={x.index} direction="row">
                  <a>
                    {x.ckey} is {x.rank}
                  </a>
                  {admin && (
                    <a>
                      <GetAdminInfo
                        hidden={x.hidden}
                        state={x.state}
                        state_color={x.state_color}
                        afk={x.afk}
                        afk_color={x.afk_color}
                      />
                    </a>
                  )}
                </Box>
              ))}
            </Box>
            <Divider />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const GetAdminInfo = (props, context) => {
  const { hidden, state, state_color, afk, afk_color } = props;

  return (
    <a>
      {hidden && <a> ({hidden})</a>}
      {state && <a color={state_color}> - {state}</a>}
      {afk && <a color={afk_color}> ({afk})</a>}
    </a>
  );
};
