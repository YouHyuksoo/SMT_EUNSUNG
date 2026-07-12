"use client";
import { useCallback,useState } from "react";
import { RefreshCw,Route } from "lucide-react";
import { useTranslation } from "react-i18next";
import { Button,Card,CardContent } from "@/components/ui";
import RoutingGroupManager from "./components/RoutingGroupManager";
import RoutingMaterialEditor from "./components/RoutingMaterialEditor";
import type { SelectedProcess } from "./types";
export default function RoutingPage(){const{t}=useTranslation();const[selectedProcess,setSelectedProcess]=useState<SelectedProcess|null>(null);const[refreshKey,setRefreshKey]=useState(0);const refresh=useCallback(()=>{setRefreshKey(k=>k+1);setSelectedProcess(null)},[]);return <div className="h-full flex flex-col overflow-hidden p-6 gap-3"><header className="flex justify-between"><div><h1 className="flex items-center gap-2 text-lg font-bold"><Route className="w-6 h-6 text-primary"/>{t("master.routing.title")}</h1><p className="text-sm text-text-muted">{t("master.routing.subtitle")}</p></div><Button variant="secondary" size="sm" onClick={refresh}><RefreshCw className="w-4 h-4 mr-1"/>{t("common.refresh")}</Button></header><div className="grid grid-cols-12 gap-4 min-h-0 flex-1"><div className="col-span-8 min-h-0"><RoutingGroupManager key={refreshKey} selectedProcess={selectedProcess} onSelectProcess={setSelectedProcess}/></div><Card padding="none" className="col-span-4 min-h-0"><CardContent className="h-full p-4">{selectedProcess?<RoutingMaterialEditor selectedProcess={selectedProcess}/>:<div className="flex h-full items-center justify-center text-sm text-text-muted">{t("master.routing.selectItemPrompt")}</div>}</CardContent></Card></div></div>}
