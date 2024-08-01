import { map, sortBy } from 'common/collections';
import { useState } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  Icon,
  Input,
  LabeledList,
  Modal,
  ProgressBar,
  Section,
  Tabs,
  VirtualList,
} from '../components';
import { NtosWindow, Window } from '../layouts';
import { Experiment } from './ExperimentConfigure';

// Data reshaping / ingestion (thanks stylemistake for the help, very cool!)
// This is primarily necessary due to measures that are taken to reduce the size
// of the sent static JSON payload to as minimal of a size as possible
// as larger sizes cause a delay for the user when opening the UI.

const remappingIdCache = {};
const remapId = (id) => remappingIdCache[id];

const selectRemappedStaticData = (data) => {
  // Handle reshaping of node cache to fill in unsent fields, and
  // decompress the node IDs
  const node_cache = {};
  for (let id of Object.keys(data.static_data.node_cache)) {
    const node = data.static_data.node_cache[id];
    const costs = Object.keys(node.costs || {}).map((x) => ({
      type: remapId(x),
      value: node.costs[x],
    }));
    node_cache[remapId(id)] = {
      ...node,
      id: remapId(id),
      costs,
      prereq_ids: map(node.prereq_ids || [], remapId),
      design_ids: map(node.design_ids || [], remapId),
      unlock_ids: map(node.unlock_ids || [], remapId),
      required_experiments: node.required_experiments || [],
      discount_experiments: node.discount_experiments || [],
    };
  }

  // Do the same as the above for the design cache
  const design_cache = {};
  for (let id of Object.keys(data.static_data.design_cache)) {
    const [name, classes] = data.static_data.design_cache[id];
    design_cache[remapId(id)] = {
      name: name,
      class: classes.startsWith('design') ? classes : `design32x32 ${classes}`,
    };
  }

  return {
    node_cache,
    design_cache,
  };
};

let remappedStaticData;

const useRemappedBackend = () => {
  const { data, ...rest } = useBackend();
  // Only remap the static data once, cache for future use
  if (!remappedStaticData) {
    const id_cache = data.static_data.id_cache;
    for (let i = 0; i < id_cache.length; i++) {
      remappingIdCache[i + 1] = id_cache[i];
    }
    remappedStaticData = selectRemappedStaticData(data);
  }
  return {
    data: {
      ...data,
      ...remappedStaticData,
    },
    ...rest,
  };
};

// Actual Components

export const Techweb = (props) => {
  return (
    <Window width={640} height={735}>
      <Window.Content scrollable>
        <TechwebStart />
      </Window.Content>
    </Window>
  );
};

const TechwebStart = (props) => {
  const { act, data } = useBackend();
  const { locked, stored_research } = data;
  if (locked) {
    return (
      <Modal width="15em" align="center" className="Techweb__LockedModal">
        <div>
          <b>Консоль заблокирована</b>
        </div>
        <Button icon="unlock" onClick={() => act('toggleLock')}>
          Разблокировать
        </Button>
      </Modal>
    );
  }
  if (!stored_research) {
    return (
      <Modal width="25em" align="center" className="Techweb__LockedModal">
        <div>
          <b>Не обнаружена техсеть. Пожалуйста, синхронизируйте консоль.</b>
        </div>
      </Modal>
    );
  }
  return <TechwebContent />;
};

export const AppTechweb = (props) => {
  const { act, data } = useRemappedBackend();
  const { locked } = data;
  return (
    <NtosWindow width={640} height={735}>
      <NtosWindow.Content scrollable>
        <TechwebStart />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const TechwebContent = (props) => {
  const { act, data } = useRemappedBackend();
  const {
    points,
    points_last_tick,
    web_org,
    sec_protocols,
    t_disk,
    d_disk,
    locked,
    queue_nodes = [],
    node_cache,
  } = data;
  const [techwebRoute, setTechwebRoute] = useLocalState('techwebRoute', null);
  const [lastPoints, setLastPoints] = useState({});

  return (
    <Flex direction="column" className="Techweb__Viewport" height="100%">
      <Flex.Item className="Techweb__HeaderSection">
        <Flex className="Techweb__HeaderContent">
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item label="Защита">
                <span
                  className={`Techweb__SecProtocol ${
                    !!sec_protocols && 'engaged'
                  }`}
                >
                  {sec_protocols ? 'Включена' : 'Отключена'}
                </span>
              </LabeledList.Item>
              {Object.keys(points).map((k) => (
                <LabeledList.Item key={k} label="Очки">
                  <b>{points[k]}</b>
                  {!!points_last_tick[k] && ` (+${points_last_tick[k]}/сек)`}
                </LabeledList.Item>
              ))}
              <LabeledList.Item label="Очередь">
                {queue_nodes.length !== 0
                  ? Object.keys(queue_nodes).map((node_id) => (
                      <Button
                        key={node_id}
                        tooltip={`Добавлено: ${queue_nodes[node_id]}`}
                      >
                        {node_cache[node_id].name}
                      </Button>
                    ))
                  : 'Пусто'}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
          <Flex.Item grow={1} />
          <Flex.Item>
            <Button fluid onClick={() => act('toggleLock')} icon="lock">
              Заблокировать консоль
            </Button>
            {d_disk && (
              <Flex.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'design' })
                  }
                >
                  Диск дизайнов вставлен
                </Button>
              </Flex.Item>
            )}
            {t_disk && (
              <Flex.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'tech' })
                  }
                >
                  Диск технологий вставлен
                </Button>
              </Flex.Item>
            )}
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item className="Techweb__RouterContent" height="100%">
        <TechwebRouter />
      </Flex.Item>
    </Flex>
  );
};

const TechwebRouter = (props) => {
  const [techwebRoute] = useLocalState('techwebRoute', null);

  const route = techwebRoute?.route;
  const RoutedComponent =
    (route === 'details' && TechwebNodeDetail) ||
    (route === 'disk' && TechwebDiskMenu) ||
    TechwebOverview;

  return <RoutedComponent {...techwebRoute} />;
};

const TechwebOverview = (props) => {
  const { act, data } = useRemappedBackend();
  const { nodes, node_cache, design_cache } = data;
  const [tabIndex, setTabIndex] = useState(1);
  const [searchText, setSearchText] = useLocalState('searchText');

  // Only search when 3 or more characters have been input
  const searching = searchText && searchText.trim().length > 1;

  let displayedNodes = nodes;
  if (searching) {
    displayedNodes = displayedNodes.filter((x) => {
      const n = node_cache[x.id];
      return (
        n.name.toLowerCase().includes(searchText) ||
        n.description.toLowerCase().includes(searchText) ||
        n.design_ids.some((e) =>
          design_cache[e].name.toLowerCase().includes(searchText),
        )
      );
    });
  } else {
    displayedNodes = sortBy(
      tabIndex < 2
        ? nodes.filter((x) => x.tier === tabIndex)
        : nodes.filter((x) => x.tier >= tabIndex),
      (x) => node_cache[x.id].name,
    );
  }

  const switchTab = (tab) => {
    setTabIndex(tab);
    setSearchText(null);
  };

  return (
    <Flex direction="column" height="100%">
      <Flex.Item>
        <Flex justify="space-between" className="Techweb__HeaderSectionTabs">
          <Flex.Item align="center" className="Techweb__HeaderTabTitle">
            Просмотр техсети
          </Flex.Item>
          <Flex.Item grow={1}>
            <Tabs>
              <Tabs.Tab
                selected={!searching && tabIndex === 0}
                onClick={() => switchTab(0)}
              >
                Изучено
              </Tabs.Tab>
              <Tabs.Tab
                selected={!searching && tabIndex === 1}
                onClick={() => switchTab(1)}
              >
                Доступно
              </Tabs.Tab>
              <Tabs.Tab
                selected={!searching && tabIndex === 2}
                onClick={() => switchTab(2)}
              >
                В будущем
              </Tabs.Tab>
              {!!searching && <Tabs.Tab selected>Поиск</Tabs.Tab>}
            </Tabs>
          </Flex.Item>
          <Flex.Item align={'center'}>
            <Input
              value={searchText}
              onInput={(e, value) => setSearchText(value)}
              placeholder={'Поиск...'}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item className={'Techweb__OverviewNodes'} height="100%">
        <VirtualList key={tabIndex + searchText}>
          {displayedNodes.map((n) => {
            return <TechNode node={n} key={n.id} />;
          })}
        </VirtualList>
      </Flex.Item>
    </Flex>
  );
};

const TechwebNodeDetail = (props) => {
  const { act, data } = useRemappedBackend();
  const { nodes } = data;
  const { selectedNode } = props;

  const selectedNodeData =
    selectedNode && nodes.find((x) => x.id === selectedNode);
  return <TechNodeDetail node={selectedNodeData} />;
};

const TechwebDiskMenu = (props) => {
  const { act, data } = useRemappedBackend();
  const { diskType } = props;
  const { t_disk, d_disk } = data;
  const [techwebRoute, setTechwebRoute] = useLocalState('techwebRoute', null);

  // Check for the disk actually being inserted
  if ((diskType === 'design' && !d_disk) || (diskType === 'tech' && !t_disk)) {
    return null;
  }

  const DiskContent =
    (diskType === 'design' && TechwebDesignDisk) || TechwebTechDisk;
  return (
    <Flex direction="column" height="100%">
      <Flex.Item>
        <Flex justify="space-between" className="Techweb__HeaderSectionTabs">
          <Flex.Item align="center" className="Techweb__HeaderTabTitle">
            {diskType.charAt(0).toUpperCase() + diskType.slice(1)} Disk
          </Flex.Item>
          <Flex.Item grow={1}>
            <Tabs>
              <Tabs.Tab selected>Записанная информация</Tabs.Tab>
            </Tabs>
          </Flex.Item>
          <Flex.Item align="center">
            {diskType === 'tech' && (
              <Button icon="save" onClick={() => act('loadTech')}>
                Сеть &rarr; Диск
              </Button>
            )}
            <Button
              icon="upload"
              onClick={() => act('uploadDisk', { type: diskType })}
            >
              Диск &rarr; Сеть
            </Button>
            <Button
              icon="eject"
              onClick={() => {
                act('ejectDisk', { type: diskType });
                setTechwebRoute(null);
              }}
            >
              Eject
            </Button>
            <Button icon="home" onClick={() => setTechwebRoute(null)}>
              Home
            </Button>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item grow={1} className="Techweb__OverviewNodes">
        <DiskContent />
      </Flex.Item>
    </Flex>
  );
};

const TechwebDesignDisk = (props) => {
  const { act, data } = useRemappedBackend();
  const { design_cache, d_disk } = data;
  const { blueprints } = d_disk;

  return (
    <>
      {blueprints.map((x, i) => (
        <Section key={i} title={`Слот ${i + 1}`}>
          {(x === null && 'Пусто') || (
            <>
              Содержит дизайн для <b>{design_cache[x].name}</b>:<br />
              <span
                className={`${design_cache[x].class} Techweb__DesignIcon`}
              />
            </>
          )}
        </Section>
      ))}
    </>
  );
};

const TechwebTechDisk = (props) => {
  const { act, data } = useRemappedBackend();
  const { t_disk } = data;
  const { stored_research } = t_disk;

  return Object.keys(stored_research)
    .map((x) => ({ id: x }))
    .map((n) => <TechNode key={n.id} nocontrols node={n} />);
};

const TechNodeDetail = (props) => {
  const { act, data } = useRemappedBackend();
  const { nodes, node_cache } = data;
  const { node } = props;
  const { id } = node;
  const { prereq_ids, unlock_ids } = node_cache[id];
  const [tabIndex, setTabIndex] = useState(0);
  const [techwebRoute, setTechwebRoute] = useLocalState('techwebRoute', null);

  const prereqNodes = nodes.filter((x) => prereq_ids.includes(x.id));
  const complPrereq = prereq_ids.filter(
    (x) => nodes.find((y) => y.id === x)?.tier === 0,
  ).length;
  const unlockedNodes = nodes.filter((x) => unlock_ids.includes(x.id));

  return (
    <Flex direction="column" height="100%">
      <Flex.Item shrink={1}>
        <Flex justify="space-between" className="Techweb__HeaderSectionTabs">
          <Flex.Item align="center" className="Techweb__HeaderTabTitle">
            Узел
          </Flex.Item>
          <Flex.Item grow={1}>
            <Tabs>
              <Tabs.Tab
                selected={tabIndex === 0}
                onClick={() => setTabIndex(0)}
              >
                Требования ({complPrereq}/{prereqNodes.length})
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 1}
                disabled={unlockedNodes.length === 0}
                onClick={() => setTabIndex(1)}
              >
                Разблокирует ({unlockedNodes.length})
              </Tabs.Tab>
            </Tabs>
          </Flex.Item>
          <Flex.Item align="center">
            <Button icon="home" onClick={() => setTechwebRoute(null)}>
              На главную
            </Button>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item className="Techweb__OverviewNodes" shrink={0}>
        <TechNode node={node} nodetails />
        <Divider />
      </Flex.Item>
      {tabIndex === 0 && (
        <Flex.Item className="Techweb__OverviewNodes" grow={1}>
          {prereqNodes.map((n) => (
            <TechNode key={n.id} node={n} />
          ))}
        </Flex.Item>
      )}
      {tabIndex === 1 && (
        <Flex.Item className="Techweb__OverviewNodes" grow={1}>
          {unlockedNodes.map((n) => (
            <TechNode key={n.id} node={n} />
          ))}
        </Flex.Item>
      )}
    </Flex>
  );
};

const TechNode = (props) => {
  const { act, data } = useRemappedBackend();
  const {
    node_cache,
    design_cache,
    experiments,
    points = [],
    nodes,
    point_types_abbreviations = [],
    queue_nodes = [],
  } = data;
  const { node, nodetails, nocontrols } = props;
  const {
    id,
    can_unlock,
    have_experiments_done,
    tier,
    enqueued_by_user,
    is_free,
  } = node;
  const {
    name,
    description,
    costs,
    design_ids,
    prereq_ids,
    required_experiments,
    discount_experiments,
  } = node_cache[id];
  const [techwebRoute, setTechwebRoute] = useLocalState('techwebRoute', null);
  const [tabIndex, setTabIndex] = useState(0);

  const expcompl = required_experiments.filter(
    (x) => experiments[x]?.completed,
  ).length;
  const experimentProgress = (
    <ProgressBar
      ranges={{
        good: [0.5, Infinity],
        average: [0.25, 0.5],
        bad: [-Infinity, 0.25],
      }}
      value={expcompl / required_experiments.length}
    >
      Эксперименты ({expcompl}/{required_experiments.length})
    </ProgressBar>
  );

  const techcompl = prereq_ids.filter(
    (x) => nodes.find((y) => y.id === x)?.tier === 0,
  ).length;
  const techProgress = (
    <ProgressBar
      ranges={{
        good: [0.5, Infinity],
        average: [0.25, 0.5],
        bad: [-Infinity, 0.25],
      }}
      value={techcompl / prereq_ids.length}
    >
      Технологии ({techcompl}/{prereq_ids.length})
    </ProgressBar>
  );

  // Notice that this logic will have to be changed if we make the discounts
  // pool-specific
  const nodeDiscount = Object.keys(discount_experiments)
    .filter((x) => experiments[x]?.completed)
    .reduce((tot, curr) => {
      return tot + discount_experiments[curr];
    }, 0);

  return (
    <Section
      className="Techweb__NodeContainer"
      title={name}
      buttons={
        !nocontrols && (
          <>
            {tier > 0 &&
              (!!can_unlock && (is_free || queue_nodes.length === 0) ? (
                <Button
                  icon="lightbulb"
                  disabled={!can_unlock || tier > 1 || queue_nodes.length > 0}
                  onClick={() => act('researchNode', { node_id: id })}
                >
                  Изучить
                </Button>
              ) : enqueued_by_user ? (
                <Button
                  icon="trash"
                  color="bad"
                  onClick={() => act('dequeueNode', { node_id: id })}
                >
                  Убрать из очереди
                </Button>
              ) : id in queue_nodes && !enqueued_by_user ? (
                <Button icon="check" color="good">
                  В очереди
                </Button>
              ) : (
                <Button
                  icon="lightbulb"
                  disabled={
                    !have_experiments_done ||
                    id in queue_nodes ||
                    techcompl < prereq_ids.length
                  }
                  onClick={() => act('enqueueNode', { node_id: id })}
                >
                  Добавить в очередь
                </Button>
              ))}
            {!nodetails && (
              <Button
                icon="tasks"
                onClick={() => {
                  setTechwebRoute({ route: 'details', selectedNode: id });
                  setTabIndex(0);
                }}
              >
                Детали
              </Button>
            )}
          </>
        )
      }
    >
      {tier !== 0 && (
        <Flex className="Techweb__NodeProgress">
          {costs.map((k) => {
            const reqPts = Math.max(0, k.value - nodeDiscount);
            const nodeProg = Math.min(reqPts, points[k.type]) || 0;
            return (
              <Flex.Item key={k.type} grow={1} basis={0}>
                <ProgressBar
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0.25, 0.5],
                    bad: [-Infinity, 0.25],
                  }}
                  value={
                    reqPts === 0
                      ? 1
                      : Math.min(1, (points[k.type] || 0) / reqPts)
                  }
                >
                  {point_types_abbreviations[k.type]} ({nodeProg}/{reqPts})
                </ProgressBar>
              </Flex.Item>
            );
          })}
          {prereq_ids.length > 0 && (
            <Flex.Item grow={1} basis={0}>
              {techProgress}
            </Flex.Item>
          )}
          {required_experiments.length > 0 && (
            <Flex.Item grow={1} basis={0}>
              {experimentProgress}
            </Flex.Item>
          )}
        </Flex>
      )}
      <Box className="Techweb__NodeDescription" mb={2}>
        {description}
      </Box>
      <Box className="Techweb__NodeUnlockedDesigns" mb={2}>
        {design_ids.map((k, i) => (
          <Button
            key={k}
            className={`${design_cache[k].class} Techweb__DesignIcon`}
            tooltip={design_cache[k].name}
            tooltipPosition={i % 15 < 7 ? 'right' : 'left'}
          />
        ))}
      </Box>
      {required_experiments.length > 0 && (
        <Collapsible
          className="Techweb__NodeExperimentsRequired"
          title="Необходимые эксперименты"
        >
          {required_experiments.map((k, index) => {
            const thisExp = experiments[k];
            if (thisExp === null || thisExp === undefined) {
              return <LockedExperiment key={index} />;
            }
            return <Experiment key={thisExp} exp={thisExp} />;
          })}
        </Collapsible>
      )}
      {Object.keys(discount_experiments).length > 0 && (
        <Collapsible
          className="TechwebNodeExperimentsRequired"
          title="Эксперименты для скидки"
        >
          {Object.keys(discount_experiments).map((k, index) => {
            const thisExp = experiments[k];
            if (thisExp === null || thisExp === undefined) {
              return <LockedExperiment key={index} />;
            }
            return (
              <Experiment key={thisExp} exp={thisExp}>
                <Box className="Techweb__ExperimentDiscount">
                  Предоставляет скидку в виде {discount_experiments[k]} очков
                  подходящим технологиям.
                </Box>
              </Experiment>
            );
          })}
        </Collapsible>
      )}
    </Section>
  );
};

const LockedExperiment = (props) => {
  return (
    <Box m={1} className="ExperimentConfigure__ExperimentPanel">
      <Button
        fluid
        backgroundColor="#40628a"
        className="ExperimentConfigure__ExperimentName"
        disabled
      >
        <Flex align="center" justify="space-between">
          <Flex.Item color="rgba(0, 0, 0, 0.6)">
            <Icon name="lock" />
            Неизвестный эксперимент
          </Flex.Item>
          <Flex.Item color="rgba(0, 0, 0, 0.5)">???</Flex.Item>
        </Flex>
      </Button>
      <Box className={'ExperimentConfigure__ExperimentContent'}>
        Этот эксперимент еще не известен. Продолжайте изучать технологии, чтобы
        распознать его.
      </Box>
    </Box>
  );
};
