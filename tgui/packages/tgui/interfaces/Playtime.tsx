import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Tabs } from '../components';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

interface PlaytimeRecord {
  job: string;
  playtime: number;
  bgcolor: string;
  textcolor: string;
  icondisplay: string | undefined;
}

interface PlaytimeRecordGlob {
  ckey: string;
  job: string;
  playtime: number;
  bgcolor: string;
  textcolor: string;
  icondisplay: string | undefined;
}

interface PlaytimeRowsPrivate {
  stored_human_playtime: PlaytimeRecord[];
  stored_xeno_playtime: PlaytimeRecord[];
  stored_other_playtime: PlaytimeRecord[];
}

interface PlaytimeRows {
  playtime: PlaytimeRowsPrivate;
  playtimeglob: PlaytimeRecordGlob[];
}

const PlaytimeRow = (props: { data: PlaytimeRecord }, context) => {
  return (
    <>
      <TableCell className="AwardCell">
        {props.data.icondisplay && (
          <span
            className={classes([
              'AwardIcon',
              'playtimerank32x32',
              props.data.icondisplay,
            ])}
          />
        )}
      </TableCell>
      <TableCell>
        <span className="LabelSpan">{props.data.job}</span>
      </TableCell>
      <TableCell>
        <span className="TimeSpan">{props.data.playtime.toFixed(1)} hr</span>
      </TableCell>
    </>
  );
};

const PlaytimeRowGlob = (props: { data: PlaytimeRecordGlob }, context) => {
  return (
    <>
      <TableCell className="AwardCell">
        {props.data.icondisplay && (
          <span
            className={classes([
              'AwardIcon',
              'playtimerank32x32',
              props.data.icondisplay,
            ])}
          />
        )}
      </TableCell>
      <TableCell>
        <span className="LabelSpan">{props.data.job}</span>
      </TableCell>
      <TableCell>
        <span className="CkeySpan">{props.data.ckey}</span>
      </TableCell>
      <TableCell>
        <span className="TimeSpan">{props.data.playtime.toFixed(1)} hr</span>
      </TableCell>
    </>
  );
};

const PlaytimeTable = (props: { data: PlaytimeRecord[] }, context) => {
  return (
    <Table>
      {props.data
        .slice(props.data.length > 1 ? 1 : 0)
        .filter((x) => x.playtime !== 0)
        .map((x) => (
          <TableRow key={x.job} className="PlaytimeRow">
            <PlaytimeRow data={x} />
          </TableRow>
        ))}
    </Table>
  );
};

const PlaytimeTableGlob = (props: { data: PlaytimeRecordGlob[] }, context) => {
  return (
    <Table>
      {props.data
        .filter((x) => x.playtime !== 0)
        .map((x) => (
          <TableRow key={x.job} className="PlaytimeRowGlob">
            <PlaytimeRowGlob data={x} />
          </TableRow>
        ))}
    </Table>
  );
};

export const Playtime = (props, context) => {
  const { data } = useBackend<PlaytimeRows>(context);
  const { playtime, playtimeglob } = data;
  const [selected, setSelected] = useLocalState(context, 'selected', 'private');
  const [selectedplaytime, setSelectedplaytime] = useLocalState(
    context,
    'selected',
    'human'
  );
  const humanTime =
    playtime.stored_human_playtime.length > 0
      ? playtime.stored_human_playtime[0].playtime
      : 0;
  const xenoTime =
    playtime.stored_xeno_playtime.length > 0
      ? playtime.stored_xeno_playtime[0].playtime
      : 0;
  const otherTime =
    playtime.stored_other_playtime.length > 0
      ? playtime.stored_other_playtime[0].playtime
      : 0;

  return (
    <Window theme={selected !== 'xeno' ? 'usmc' : 'hive_status'}>
      <Window.Content className="PlaytimeInterface" scrollable>
        <Tabs fluid={1}>
          <Tabs.Tab
            selected={selected === 'global'}
            onClick={() => setSelected('global')}>
            Global
          </Tabs.Tab>
          <Tabs.Tab
            selected={selected === 'private'}
            onClick={() => setSelected('private')}>
            Private
          </Tabs.Tab>
        </Tabs>
        {selected === 'global' ? (
          <Table>
            <PlaytimeTableGlob data={playtimeglob} />
          </Table>
        ) : (
          <Table>
            <Tabs fluid={1}>
              <Tabs.Tab
                selectedplaytime={selectedplaytime === 'human'}
                onClick={() => setSelectedplaytime('human')}>
                Human ({humanTime} hr)
              </Tabs.Tab>
              <Tabs.Tab
                selectedplaytime={selectedplaytime === 'xeno'}
                onClick={() => setSelectedplaytime('xeno')}>
                Xeno ({xenoTime} hr)
              </Tabs.Tab>
              <Tabs.Tab
                selectedplaytime={selectedplaytime === 'other'}
                onClick={() => setSelectedplaytime('other')}>
                Other ({otherTime} hr)
              </Tabs.Tab>
            </Tabs>
            {selectedplaytime === 'human' && (
              <PlaytimeTable data={playtime.stored_human_playtime} />
            )}
            {selectedplaytime === 'xeno' && (
              <PlaytimeTable data={playtime.stored_xeno_playtime} />
            )}
            {selectedplaytime === 'other' && (
              <PlaytimeTable data={playtime.stored_other_playtime} />
            )}
          </Table>
        )}
      </Window.Content>
    </Window>
  );
};
