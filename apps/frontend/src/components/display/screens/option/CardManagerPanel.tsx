'use client';

import { useCallback, useEffect, useState } from 'react';
import { useTranslations } from 'next-intl';
import Spinner from '@/components/ui/Spinner';

interface Card {
  id: string;
  title: string;
  url: string;
  color: string;
  icon: string;
  layer: number;
}

interface Category {
  id: number;
  name: string;
  subtitle: string;
  icon: string;
}

export default function CardManagerPanel() {
  const t = useTranslations('settingsCards');
  const [cards, setCards] = useState<Card[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [dirty, setDirty] = useState(false);
  const [toast, setToast] = useState('');

  const fetchCards = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/settings/cards');
      const data = await res.json();
      setCards(data.cards ?? []);
      setCategories(data.categories ?? []);
    } catch (e) {
      console.error('카드 로드 실패:', e);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { fetchCards(); }, [fetchCards]);

  const changeLayer = (cardId: string, newLayer: number) => {
    setCards((prev) => prev.map((c) => (c.id === cardId ? { ...c, layer: newLayer } : c)));
    setDirty(true);
  };

  const removeCategory = (catId: number) => {
    setCards((prev) => prev.map((c) => (c.layer === catId ? { ...c, layer: -1 } : c)));
    setCategories((prev) => prev.filter((c) => c.id !== catId));
    setDirty(true);
  };

  const removeCard = (cardId: string) => {
    setCards((prev) => prev.map((c) => (c.id === cardId ? { ...c, layer: -1 } : c)));
    setDirty(true);
  };

  const saveCards = async () => {
    setSaving(true);
    try {
      const res = await fetch('/api/settings/cards', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ categories, cards }),
      });
      if (!res.ok) throw new Error(t('saveFailed'));
      setDirty(false);
      setToast(t('saveSuccess'));
      localStorage.removeItem('mes-display-cards-cache');
      localStorage.removeItem('mes-display-categories');
      setTimeout(() => setToast(''), 2000);
    } catch (e) {
      setToast(t('errorPrefix', { error: String(e) }));
      setTimeout(() => setToast(''), 3000);
    } finally {
      setSaving(false);
    }
  };

  const grouped = categories.map((category) => ({
    category,
    cards: cards.filter((card) => card.layer === category.id),
  }));

  const unassigned = cards.filter((card) => (
    card.layer === -1 || !categories.some((category) => category.id === card.layer)
  ));

  if (loading) {
    return (
      <div className="flex h-full min-h-96 items-center justify-center bg-white dark:bg-gray-950">
        <Spinner size="lg" />
      </div>
    );
  }

  return (
    <div className="min-h-full bg-gray-50 text-gray-900 dark:bg-gray-950 dark:text-white">
      <div className="sticky top-0 z-10 border-b border-gray-200 bg-white px-6 py-4 dark:border-gray-700 dark:bg-gray-900">
        <div className="mx-auto flex max-w-5xl items-center justify-between">
          <div>
            <h1 className="text-lg font-bold">{t('title')}</h1>
            <p className="mt-0.5 text-xs text-gray-400 dark:text-gray-500">
              {t('summary', { cards: cards.length, categories: categories.length })}
            </p>
          </div>
          <div className="flex items-center gap-3">
            {dirty && <span className="text-xs font-medium text-amber-500">{t('dirty')}</span>}
            <button
              onClick={saveCards}
              disabled={!dirty || saving}
              className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-bold text-white transition-colors hover:bg-blue-500 disabled:opacity-40"
            >
              {saving ? t('saving') : t('save')}
            </button>
          </div>
        </div>
      </div>

      {toast && (
        <div className="fixed bottom-6 right-6 z-50 rounded-lg bg-gray-800 px-4 py-2 text-sm text-white shadow-lg">
          {toast}
        </div>
      )}

      <div className="mx-auto max-w-5xl space-y-6 px-6 py-6">
        {grouped.map(({ category, cards: catCards }) => (
          <div
            key={category.id}
            className="overflow-hidden rounded-xl border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900"
          >
            <div className="border-b border-gray-200 bg-gray-50 px-4 py-3 dark:border-gray-700 dark:bg-gray-800/50">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="text-lg">{category.icon}</span>
                  <span className="text-sm font-bold">{category.name}</span>
                  <span className="text-xs text-gray-400 dark:text-gray-500">
                    {t('categorySubtitle', { subtitle: category.subtitle, count: catCards.length })}
                  </span>
                </div>
                <button
                  onClick={() => removeCategory(category.id)}
                  className="rounded px-2 py-1 text-[10px] text-red-500 transition-colors hover:bg-red-50 dark:hover:bg-red-900/20"
                  title={t('removeCategoryTitle')}
                >
                  {t('removeCategory')}
                </button>
              </div>
            </div>

            {catCards.length === 0 ? (
              <div className="px-4 py-6 text-center text-xs text-gray-400 dark:text-gray-600">
                {t('emptyCategory')}
              </div>
            ) : (
              <div className="divide-y divide-gray-100 dark:divide-gray-800">
                {catCards.map((card) => (
                  <CardRow
                    key={card.id}
                    card={card}
                    categories={categories}
                    onChangeLayer={changeLayer}
                    onRemove={removeCard}
                  />
                ))}
              </div>
            )}
          </div>
        ))}

        <div className="overflow-hidden rounded-xl border border-amber-300 bg-white dark:border-amber-700 dark:bg-gray-900">
          <div className="border-b border-amber-200 bg-amber-50 px-4 py-3 dark:border-amber-800 dark:bg-amber-900/20">
            <span className="text-sm font-bold text-amber-600 dark:text-amber-400">
              {t('unassignedTitle', { count: unassigned.length })}
            </span>
          </div>
          {unassigned.length === 0 ? (
            <div className="px-4 py-6 text-center text-xs text-gray-400 dark:text-gray-600">
              {t('unassignedEmpty')}
            </div>
          ) : (
            <div className="divide-y divide-gray-100 dark:divide-gray-800">
              {unassigned.map((card) => (
                <CardRow
                  key={card.id}
                  card={card}
                  categories={categories}
                  onChangeLayer={changeLayer}
                  onRemove={removeCard}
                />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function CardRow({
  card,
  categories,
  onChangeLayer,
  onRemove,
}: {
  card: Card;
  categories: Category[];
  onChangeLayer: (id: string, layer: number) => void;
  onRemove: (id: string) => void;
}) {
  const t = useTranslations('settingsCards');
  return (
    <div className="flex items-center gap-3 px-4 py-2.5 transition-colors hover:bg-gray-50 dark:hover:bg-gray-800/40">
      <div className="h-3 w-3 shrink-0 rounded-full" style={{ backgroundColor: card.color }} />
      <div className="min-w-0 flex-1">
        <div className="truncate text-sm font-medium">{card.title}</div>
        <div className="truncate font-mono text-[10px] text-gray-400 dark:text-gray-500">{card.url}</div>
      </div>
      <select
        value={card.layer}
        onChange={(e) => onChangeLayer(card.id, Number(e.target.value))}
        className="shrink-0 rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs text-gray-700 dark:border-gray-600 dark:bg-gray-800 dark:text-gray-300"
      >
        <option value={-1}>{t('selectUnassigned')}</option>
        {categories.map((cat) => (
          <option key={cat.id} value={cat.id}>
            {cat.icon} {cat.name}
          </option>
        ))}
      </select>
      {card.layer !== -1 && (
        <button
          onClick={() => onRemove(card.id)}
          className="shrink-0 rounded px-2 py-1 text-[10px] text-red-500 transition-colors hover:bg-red-50 dark:hover:bg-red-900/20"
          title={t('removeCardTitle')}
        >
          {t('removeCard')}
        </button>
      )}
    </div>
  );
}
