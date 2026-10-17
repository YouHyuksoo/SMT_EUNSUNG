import { useEffect, useState } from "react";
import api from "@/services/api";
import type { ProductModelRow } from "./productModelColumns";

/** 모델 목록 + BOM 전개 방식 (GET /master/product-models/bom-explode) */
export function useProductModels() {
  const [data, setData] = useState<ProductModelRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [revision, setRevision] = useState(0);

  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);
    setFailed(false);
    async function load() {
      try {
        const response = await api.get<{ data: ProductModelRow[] }>(
          "/master/product-models/bom-explode", { signal: controller.signal },
        );
        if (!Array.isArray(response.data?.data)) throw new Error("Invalid model response");
        if (!controller.signal.aborted) setData(response.data.data);
      } catch (error: unknown) {
        if (!controller.signal.aborted) {
          setData([]);
          setFailed(true);
        }
      } finally {
        if (!controller.signal.aborted) setLoading(false);
      }
    }
    void load();
    return () => controller.abort();
  }, [revision]);

  return { data, loading, failed, refresh: () => setRevision(value => value + 1) };
}
